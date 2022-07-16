#load "./Utils.fsx"

open System
open Utils

// Parse input:

type Action = char * float

let parseAction (input: string) : Action = (input[0], float input[1..])

let actions =
    "./input12.txt"
    |> IO.File.ReadAllLines
    |> Array.map parseAction

// Step 1:

let degreeToRadian (degrees: float) : float = degrees * (Math.PI / 180.0)

[<Struct>]
type Vec2(x: float, y: float) =
    member this.X = x
    member this.Y = y

    static member AtAngle(degrees: float, magnitude: float) : Vec2 =
        let dy = magnitude * sin (degreeToRadian degrees)
        let dx = magnitude * cos (degreeToRadian degrees)
        Vec2(dx, dy)

    static member (+)(v1: Vec2, v2: Vec2) = Vec2(v1.X + v2.X, v1.Y + v2.Y)
    static member (-)(v1: Vec2, v2: Vec2) = Vec2(v1.X - v2.X, v1.Y - v2.Y)
    static member (*)(a: float, v: Vec2) = Vec2(a * v.X, a * v.Y)
    static member (*)(v: Vec2, a: float) = Vec2(a * v.X, a * v.Y)
    static member (/)(a: float, v: Vec2) = Vec2(v.X / a, v.Y / a)
    static member (/)(v: Vec2, a: float) = Vec2(v.X / a, v.Y / a)

    override this.ToString() = $"({this.X}, {this.Y})"

    member this.Angle() =
        Math.Atan2(this.Y, this.X) * (180. / Math.PI)

    member this.ManhattanDistance() = int (abs this.X + abs this.Y)

    member this.Magnitude() = sqrt (this.X ** 2 + this.Y ** 2)

[<Struct>]
type Ship =
    { Pos: Vec2
      Waypoint: Vec2
      Dir: float }

    static member Default =
        { Pos = Vec2(0, 0)
          Waypoint = Vec2(10, 1)
          Dir = 0 }

    override this.ToString() = $"{this.Pos}, waypoint={this.Waypoint}"

let degreeToVector (degrees: float) : Vec2 =
    let radians = degreeToRadian degrees
    Vec2(cos radians, sin radians)

let applyAction ship action =
    let { Pos = pos; Dir = dir } = ship

    match action with
    | ('N', arg) -> { ship with Pos = pos + Vec2(0, arg) }
    | ('S', arg) -> { ship with Pos = pos + Vec2(0, -arg) }
    | ('E', arg) -> { ship with Pos = pos + Vec2(arg, 0) }
    | ('W', arg) -> { ship with Pos = pos + Vec2(-arg, 0) }
    | ('L', arg) -> { ship with Dir = dir + arg }
    | ('R', arg) -> { ship with Dir = dir - arg }
    | ('F', arg) -> { ship with Pos = pos + arg * (degreeToVector dir) }
    | _ -> failwith $"invalid action {action}"

let step1 () =
    let ship = Array.fold applyAction Ship.Default actions
    ship.Pos.ManhattanDistance()

// Step 1 with a mutable record:

type MutableShip =
    { mutable Pos: Vec2
      mutable Waypoint: Vec2
      mutable Dir: float }

    static member Default =
        { Pos = Vec2(0, 0)
          Waypoint = Vec2(10, 1)
          Dir = 0 }

    override this.ToString() = $"{this.Pos}, waypoint={this.Waypoint}"

let applyMutableAction ship action : unit =
    let { MutableShip.Pos = pos
          MutableShip.Dir = dir } =
        ship

    match action with
    | ('N', arg) -> ship.Pos <- pos + Vec2(0, arg)
    | ('S', arg) -> ship.Pos <- pos + Vec2(0, -arg)
    | ('E', arg) -> ship.Pos <- pos + Vec2(arg, 0)
    | ('W', arg) -> ship.Pos <- pos + Vec2(-arg, 0)
    | ('L', arg) -> ship.Dir <- dir + arg
    | ('R', arg) -> ship.Dir <- dir - arg
    | ('F', arg) -> ship.Pos <- pos + arg * (degreeToVector dir)
    | _ -> failwith $"invalid action {action}"

let step1Mutable () =
    let ship = MutableShip.Default
    Array.iter (applyMutableAction ship) actions
    ship.Pos.ManhattanDistance()

// Step 2:

let applyWaypointAction ship action =
    let { Ship.Pos = pos; Ship.Waypoint = wp } = ship

    match action with
    | ('N', arg) -> { ship with Waypoint = wp + Vec2(0, arg) }
    | ('S', arg) -> { ship with Waypoint = wp + Vec2(0, -arg) }
    | ('E', arg) -> { ship with Waypoint = wp + Vec2(arg, 0) }
    | ('W', arg) -> { ship with Waypoint = wp + Vec2(-arg, 0) }
    | ('L', arg) ->
        let dir = (wp - pos)
        let angle = dir.Angle() + arg
        { ship with Waypoint = pos + Vec2.AtAngle(angle, dir.Magnitude()) }
    | ('R', arg) ->
        let dir = (wp - pos)
        let angle = dir.Angle() - arg
        { ship with Waypoint = pos + Vec2.AtAngle(angle, dir.Magnitude()) }
    | ('F', arg) ->
        let move = arg * (wp - pos)

        { ship with
            Pos = pos + move
            Waypoint = wp + move }
    | _ -> failwith $"invalid action {action}"

let step2 () =
    let ship = Array.fold applyWaypointAction Ship.Default actions
    ship.Pos.ManhattanDistance()

benchmark [| "step1", step1
             "step1Mutable", step1Mutable
             "step2", step2 |]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1                |                 1007 |    0 |     482322 |
| step1Mutable         |                 1007 |    0 |     369045 |
| step2                |                41212 |    0 |     709709 |
*)
