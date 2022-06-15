#load "Utils.fsx"
open Utils

// Parse input:

type BoardingPass = { Row: list<bool>; Column: list<bool> }

let boardingPasses =
    "./input05.txt"
    |> System.IO.File.ReadLines
    |> Seq.map (fun line ->
        { Row =
            line[..6]
            |> Seq.map (fun c -> c = 'B')
            |> Seq.toList
          Column =
            line[7..]
            |> Seq.map (fun c -> c = 'R')
            |> Seq.toList })

// Step 1:

let binarySpacePartition xs =
    let rec inner min max xs' =
        match xs' with
        | true :: tail -> inner (min + (max - min) / 2) max tail
        | false :: tail -> inner min (min + (max - min) / 2) tail
        | [] -> max

    inner 0 (pown 2 (List.length xs) - 1) xs

let getSeatId (boardingPass: BoardingPass) =
    (binarySpacePartition boardingPass.Row * 8)
    + binarySpacePartition boardingPass.Column

let step1 () =
    boardingPasses
    |> Seq.map getSeatId
    |> Seq.sort
    |> Seq.last

// Step 2:

let step2 () =
    let seatIds =
        boardingPasses
        |> Seq.map getSeatId
        |> Seq.sort
        |> Seq.mapi (fun i x -> (i, x))
        |> Seq.toArray

    let (_, seatIdAfterMySeat) =
        seatIds
        |> Array.find (fun (i, x) -> i > 0 && (snd seatIds[i - 1]) <> (x - 1))

    seatIdAfterMySeat - 1

benchmark [| ("step1", step1)
             ("step2", step2) |]
