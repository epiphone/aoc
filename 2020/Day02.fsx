#load "Utils.fsx"

open Utils
open System.Text.RegularExpressions

// Input parsing:

type Row = int * int * char * string

let regex = Regex("^(\d+)-(\d+) (\w): (\w+)$", RegexOptions.Compiled)

let parseRow row : Row =
    match row with
    | ParseRegex regex [ _; Int minCount; Int maxCount; Char letter; password ] ->
        (minCount, maxCount, letter, password)
    | _ -> failwith $"failed to parse row: {row}"

let rows =
    "./input02.txt"
    |> System.IO.File.ReadLines
    |> Seq.map parseRow

// Step 1:

let charCount (str: string) target =
    Seq.fold (fun acc c -> acc + if c = target then 1 else 0) 0 str

let step1IsValid ((minCount, maxCount, letter, password): Row) =
    let count = charCount password letter
    minCount <= count && count <= maxCount

let countBy predicate xs =
    Seq.fold (fun acc x -> acc + if predicate x then 1 else 0) 0 xs

let step1 () = countBy step1IsValid rows

// Step 2:

let xor (a: bool) (b: bool) = a <> b

let step2IsValid ((minCount, maxCount, letter, password): Row) =
    let firstPos = password[minCount - 1]
    let secondPos = password[maxCount - 1]

    xor (firstPos = letter) (secondPos = letter)

let step2 () = countBy step2IsValid rows

benchmark [ ("step1", step1)
            ("step2", step2) ]
