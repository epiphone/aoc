#load "Utils.fsx"
open Utils

// Parse input:

let groups =
    "./input06.txt"
    |> System.IO.File.ReadAllText
    |> (fun text -> text.Split("\n\n", System.StringSplitOptions.TrimEntries))

// Step 1:

let uniqueYesAnswers (group: string) =
    group
    |> Seq.filter System.Char.IsLetter
    |> Seq.distinct
    |> Seq.length

let step1 () = groups |> Array.sumBy uniqueYesAnswers

// Step 2:

let commonYesAnswers (group: string) =
    group.Split('\n')
    |> Seq.map Set.ofSeq
    |> Set.intersectMany
    |> Set.count

let step2 () = groups |> Array.sumBy commonYesAnswers

// Step 1 with BitArray:

let answersAsBitArray (answers: string) =
    let ba = System.Collections.BitArray 97

    for c in answers do
        ba.Set(int c - 97, true)

    ba

let yesAnswerCount (answers: System.Collections.BitArray) =
    let rec loop i acc =
        match i with
        | i when i = answers.Length -> acc
        | i when answers[i] = true -> loop (i + 1) (acc + 1)
        | _ -> loop (i + 1) acc

    loop 0 0

let uniqueYesAnswersBitArray (group: string) =
    group.Split('\n')
    |> Array.map answersAsBitArray
    |> Array.reduce (fun acc ba -> acc.Or ba)
    |> yesAnswerCount

let step1BitArray () =
    groups |> Array.sumBy uniqueYesAnswersBitArray

// Step 2 with BitArray:

let commonYesAnswersBitArray (group: string) =
    group.Split('\n')
    |> Array.map answersAsBitArray
    |> Array.reduce (fun acc ba -> acc.And ba)
    |> yesAnswerCount

let step2BitArray () =
    groups |> Array.sumBy commonYesAnswersBitArray

benchmark [| ("step1", step1)
             ("step2", step2)
             ("step1BitArray", step1BitArray)
             ("step2BitArray", step2BitArray) |]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1                |                 6583 |    8 |    8987563 |
| step2                |                 3290 |   30 |   30526391 |
| step1BitArray        |                 6583 |    2 |    2688311 |
| step2BitArray        |                 3290 |    2 |    2752686 |
*)
