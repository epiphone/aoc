#load "Utils.fsx"
open Utils

// Parse input:

type Square =
    | Open
    | Tree

type Grid = array<array<Square>>

let lines = "./input03.txt" |> System.IO.File.ReadLines

let grid: Grid =
    [| for line in lines -> [| for c in line -> if c = '.' then Open else Tree |] |]

// Step 1:

let mapToSlope w (x, y) = (x % w, y)

let numberOfTreesInSlope (grid: Grid) (movX, movY) =
    let (w, h) = (grid[0].Length, grid.Length)
    let pointCount = (h - 1) / movY

    let mutable res = 0

    for i = 0 to pointCount do
        let (x, y) = mapToSlope w (movX * i, movY * i)
        res <- res + if grid[y][x] = Tree then 1 else 0

    res

let step1 () = numberOfTreesInSlope grid (3, 1)

// Step 2:

let step2 () =
    [ (1, 1)
      (3, 1)
      (5, 1)
      (7, 1)
      (1, 2) ]
    |> List.map (numberOfTreesInSlope grid)
    |> List.map int64
    |> List.reduce (*)

benchmark [ ("step1", (fun () -> step1 () |> int64))
            ("step2", step2) ]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1                |                  268 |    0 |      16859 |
| step2                |           3093068400 |    0 |      96728 |
*)
