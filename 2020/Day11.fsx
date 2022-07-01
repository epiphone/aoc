#load "./Utils.fsx"

open Utils

// Parse input:

type Grid = char [] []

let parseInput () : Grid =
    "./input11.txt"
    |> System.IO.File.ReadAllLines
    |> Array.map Seq.toArray

let step1Input = parseInput ()
let step2Input = parseInput ()

// Step 1:

let simulate (grid: Grid) (gridClone: Grid) (getNewTile: Grid -> (int * int) -> char) : bool =
    let mutable changed = false

    for y = 0 to (grid.Length - 1) do
        for x = 0 to (grid[0].Length - 1) do
            gridClone[y][x] <- grid[y][x]

    for y = 0 to (grid.Length - 1) do
        for x = 0 to (grid[0].Length - 1) do
            let tile = getNewTile gridClone (x, y)

            if tile <> grid[y][x] then
                changed <- true

            grid[y][x] <- tile

    changed

let adjacentOccupiedSeatCount (grid: Grid) (xPos, yPos) =
    let mutable count = 0
    let minY = max 0 (yPos - 1)
    let maxY = min (grid.Length - 1) (yPos + 1)
    let minX = max 0 (xPos - 1)
    let maxX = min (grid[0].Length - 1) (xPos + 1)

    for y = minY to maxY do
        for x = minX to maxX do
            if grid[y][x] = '#' && (x, y) <> (xPos, yPos) then
                count <- count + 1

    count

// let rec loop acc (x, y) =
//     let isOccupied = grid[y][x] = '#' && (x, y) <> (xPos, yPos)
//     let newAcc = acc + if isOccupied then 1 else 0

//     if (x, y) = (maxX, maxY) then
//         newAcc
//     else if x = maxX then
//         loop newAcc (minX, y + 1)
//     else
//         loop newAcc (x + 1, y)

// loop 0 (minX, minY)

let simulateUntilEquilibrium getNewTile (grid: Grid) =
    let gridClone = [| for row in grid -> [| for tile in row -> tile |] |]

    let rec loop () =
        match simulate grid gridClone getNewTile with
        | false -> grid
        | _ -> loop ()

    loop ()

let occupiedSeatCount (grid: Grid) =
    grid
    |> Array.collect (fun row -> row |> Array.filter (fun tile -> tile = '#'))
    |> Array.length

let step1 () =
    let getNewTile (grid: Grid) (x, y) : char =
        let tile = grid[y][x]

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

let isInBounds (grid: 'a [] []) (x, y) =
    x >= 0
    && x < grid[0].Length
    && y >= 0
    && y < grid.Length

let canSeeOccupiedSeatInDirection (grid: Grid) (posX, posY) (dirX, dirY) : bool =
    let rec loop (x, y) =
        if not (isInBounds grid (x, y)) then
            false
        else
            match grid[y][x] with
            | 'L' -> false
            | '#' -> true
            | _ -> loop (x + dirX, y + dirY)

    loop (posX + dirX, posY + dirY)

let visibleOccupiedSeatCount (grid: Grid) pos =
    let mutable count = 0

    for y in -1 .. 1 do
        for x in -1 .. 1 do
            let canSeeInDir =
                (x, y) <> (0, 0)
                && canSeeOccupiedSeatInDirection grid pos (x, y)

            if canSeeInDir then count <- count + 1

    count

let step2 () =
    let getNewTile (grid: Grid) (x, y) : char =
        let tile = grid[y][x]

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
