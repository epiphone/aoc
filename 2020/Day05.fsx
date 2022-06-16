#load "Utils.fsx"
open Utils

// Parse input:

let boardingPasses = "./input05.txt" |> System.IO.File.ReadAllLines

// Step 1:

let binarySpacePartition (xs: string) =
    let rec inner min max i =
        if i = xs.Length then
            max
        else
            match xs[i] with
            | 'B'
            | 'R' -> inner (min + (max - min) / 2) max (i + 1)
            | _ -> inner min (min + (max - min) / 2) (i + 1)

    inner 0 (pown 2 (xs.Length) - 1) 0

let getSeatId (boardingPass: string) =
    (binarySpacePartition boardingPass[..6] * 8)
    + binarySpacePartition boardingPass[7..]

let step1 () =
    boardingPasses |> Seq.map getSeatId |> Seq.max

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
