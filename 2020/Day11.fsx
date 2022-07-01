#load "./Utils.fsx"

open Utils

// Parse input:

type Grid<'a> =
    { Tiles: 'a []
      W: int
      H: int }

    static member Default(rows: 'a [] []) : Grid<'a> =
        { Tiles = rows |> Array.collect id
          W = rows[0].Length
          H = rows.Length }

    member this.Get(x, y) : 'a = this.Tiles[y * this.W + x]

    member this.Set (x, y) (c: 'a) : unit = this.Tiles[ y * this.W + x ] <- c

    member this.Clone() : Grid<'a> =
        { this with Tiles = [| for t in this.Tiles -> t |] }

    member this.isInBounds(x, y) : bool =
        x >= 0 && x < this.W && y >= 0 && y < this.H

    member inline this.Iteri(action: 'a -> (int * int) -> unit) : unit =
        for y = 0 to this.H - 1 do
            for x = 0 to this.W - 1 do
                action (this.Get(x, y)) (x, y)

    member inline this.IterNeighbours (action: 'a -> unit) ((centerX, centerY): int * int) : unit =
        let minY = max 0 (centerY - 1)
        let maxY = min (this.H - 1) (centerY + 1)
        let minX = max 0 (centerX - 1)
        let maxX = min (this.W - 1) (centerX + 1)

        for y = minY to maxY do
            for x = minX to maxX do
                if (x, y) <> (centerX, centerY) then
                    action (this.Get(x, y))

let parseInput () : Grid<char> =
    "./input11.txt"
    |> System.IO.File.ReadAllLines
    |> Array.map Seq.toArray
    |> Grid.Default

let step1Input = parseInput ()
let step2Input = parseInput ()

// Step 1:

let simulate (grid: Grid<char>) (gridClone: Grid<char>) (getNewTile: Grid<char> -> (int * int) -> char) : bool =
    let mutable changed = false

    grid.Tiles.CopyTo(gridClone.Tiles, 0)

    grid.Iteri (fun _ pos ->
        let tile = getNewTile gridClone pos

        if tile <> grid.Get pos then
            changed <- true

        grid.Set pos tile)

    changed

let adjacentOccupiedSeatCount (grid: Grid<char>) (xPos, yPos) =
    let mutable count = 0

    grid.IterNeighbours (fun c -> if c = '#' then count <- count + 1) (xPos, yPos)

    count

let simulateUntilEquilibrium getNewTile (grid: Grid<char>) =
    let gridClone: Grid<char> = grid.Clone()

    let rec loop () =
        match simulate grid gridClone getNewTile with
        | false -> grid
        | _ -> loop ()

    loop ()

let occupiedSeatCount (grid: Grid<char>) : int =
    grid.Tiles
    |> Array.sumBy (fun tile -> if tile = '#' then 1 else 0)

let step1 () =
    let getNewTile (grid: Grid<char>) (x, y) : char =
        let tile = grid.Get(x, y)

        if tile <> '.' then
            let adjacentCount = adjacentOccupiedSeatCount grid (x, y)

            match adjacentCount with
            | 0 -> '#'
            | n when n >= 4 -> 'L'
            | _ -> tile
        else
            tile

    step1Input
    |> simulateUntilEquilibrium getNewTile
    |> occupiedSeatCount

// Step 2:

let canSeeOccupiedSeatInDirection (grid: Grid<char>) (posX, posY) (dirX, dirY) : bool =
    let rec loop (x, y) =
        if not (grid.isInBounds (x, y)) then
            false
        else
            match grid.Get(x, y) with
            | 'L' -> false
            | '#' -> true
            | _ -> loop (x + dirX, y + dirY)

    loop (posX + dirX, posY + dirY)

let visibleOccupiedSeatCount (grid: Grid<char>) pos =
    let mutable count = 0

    for y in -1 .. 1 do
        for x in -1 .. 1 do
            let canSeeInDir =
                (x, y) <> (0, 0)
                && canSeeOccupiedSeatInDirection grid pos (x, y)

            if canSeeInDir then count <- count + 1

    count

let step2 () =
    let getNewTile (grid: Grid<char>) (x, y) : char =
        let tile = grid.Get(x, y)

        if tile <> '.' then
            let visibleCount = visibleOccupiedSeatCount grid (x, y)

            match visibleCount with
            | 0 -> '#'
            | n when n >= 5 -> 'L'
            | _ -> tile
        else
            tile

    step2Input
    |> simulateUntilEquilibrium getNewTile
    |> occupiedSeatCount

benchmark [ ("step1", step1)
            ("step2", step2) ]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1                |                 2483 |    5 |    5194838 |
| step2                |                 2285 |    8 |    8236237 |
*)
