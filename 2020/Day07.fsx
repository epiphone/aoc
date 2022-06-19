#load "Utils.fsx"

open Utils
open System.Text.RegularExpressions

// Parse input:

type Rule = (string * seq<(int * string)>)

let contentPattern = Regex("(\d+ \w+ \w+)", RegexOptions.Compiled)

let parseRule (str: string) : Rule =
    let [| bag; contentsStr |] = str.Split(" bags contain ")

    let contents =
        contentPattern.Matches(contentsStr)
        |> Seq.map (fun m ->
            let [| count; name1; name2 |] = m.Value.Split(' ')
            (int count, $"{name1} {name2}"))

    (bag, contents)

let rules =
    "./input07.txt"
    |> System.IO.File.ReadLines
    |> Seq.map parseRule
    |> Map.ofSeq

// Step 1:

let rec canContainBag (outerBag, innerBag) =
    rules[outerBag]
    |> Seq.exists (function
        | (_, bag) when bag = innerBag -> true
        | (_, bag) -> canContainBag (bag, innerBag))

let step1 () =
    rules
    |> Map.keys
    |> Seq.filter (fun bag -> canContainBag (bag, "shiny gold"))
    |> Seq.length

// Step 1 with memoization:

let canContainBagMemoized = memoize canContainBag

let step1Memo () =
    rules
    |> Map.keys
    |> Seq.filter (fun bag -> canContainBagMemoized (bag, "shiny gold"))
    |> Seq.length

// Step 2:

let rec containedBagsCount bag =
    rules[bag]
    |> Seq.sumBy (fun (count, innerBag) -> count + count * containedBagsCount innerBag)

let step2 () = containedBagsCount "shiny gold"

benchmark [| ("step1", step1)
             ("step1Memo", step1Memo)
             ("step2", step2) |]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1                |                  238 |  990 |  990756980 |
| step1Memo            |                  238 |    1 |    1214438 |
| step2                |                82930 |    0 |     333341 |
*)
