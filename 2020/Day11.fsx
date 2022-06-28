#load "./Utils.fsx"

open Utils

// Parse input:

type Grid = char [] []

let gridStep1: Grid =
    "./input11.txt"
    |> System.IO.File.ReadAllLines
    |> Array.map Seq.toArray

let gridStep2 = [| for row in gridStep1 -> [| for tile in row -> tile |] |]

// Step 1:

let gridClone = [| for row in gridStep1 -> [| for tile in row -> tile |] |]

let simulate (grid: Grid) (getNewTile: Grid -> (int * int) -> char) : bool =
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

let simulateUntilEquilibrium grid getNewTile =
    let rec loop currGrid =
        match simulate currGrid getNewTile with
        | false -> currGrid
        | _ -> loop currGrid

    loop grid

let occupiedSeatCount (grid: Grid) =
    grid
    |> Array.map (fun row ->
        row
        |> Array.sumBy (fun tile -> if tile = '#' then 1 else 0))
    |> Array.sum

let step1 () =
    let getNewTile (grid: Grid) (x, y) : char =
        let tile = grid[y][x]

        if tile <> '.' then
            let adjacentCount = adjacentOccupiedSeatCount grid (x, y)

            match tile with
            | 'L' when adjacentCount = 0 -> '#'
            | '#' when adjacentCount >= 4 -> 'L'
            | _ -> tile
        else
            tile

    simulateUntilEquilibrium gridStep1 getNewTile
    |> occupiedSeatCount

// Step 2:

let isOutOfBounds (grid: 'a [] []) (x, y) =
    x < 0
    || x = grid[0].Length
    || y < 0
    || y = grid.Length

let canSeeOccupiedSeatInDirection (grid: Grid) (posX, posY) (dirX, dirY) : bool =
    let rec loop (x, y) =
        if isOutOfBounds grid (x, y) then
            false
        else
            match grid[y][x] with
            | 'L' -> false
            | '#' -> true
            | '.' -> loop (x + dirX, y + dirY)

    loop (posX + dirX, posY + dirY)

let visibleOccupiedSeatCount (grid: Grid) pos =
    seq {
        for y in -1 .. 1 do
            for x in -1 .. 1 do
                if (x, y) <> (0, 0) then (x, y)
    }
    |> Seq.sumBy (fun dir ->
        if canSeeOccupiedSeatInDirection grid pos dir then
            1
        else
            0)

let step2 () =
    let getNewTile (grid: Grid) (x, y) : char =
        let tile = grid[y][x]

        if tile <> '.' then
            let visibleCount = visibleOccupiedSeatCount grid (x, y)

            match tile with
            | 'L' when visibleCount = 0 -> '#'
            | '#' when visibleCount >= 5 -> 'L'
            | _ -> tile
        else
            tile

    simulateUntilEquilibrium gridStep2 getNewTile
    |> occupiedSeatCount

benchmark [ ("step1", step1)
            ("step2", step2) ]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1                |                 2483 |    3 |    3573903 |
| step2                |                 2285 |   33 |   33236388 |
*)
