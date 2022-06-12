#load "Utils.fsx"

let entries =
    "./input01.txt"
    |> System.IO.File.ReadLines
    |> Seq.map int
    |> Seq.toArray
// |> Array.sort makes all solutions faster

let target = 2020

// Step 1 using for-loops:

let pairs xs =
    seq {
        for i = 0 to Array.length xs - 2 do
            for j = i + 1 to (Array.length xs - 1) do
                yield (xs[i], xs[j])
    }

let step1ForLoops () : int =
    entries
    |> pairs
    |> Seq.find (fun (a, b) -> a + b = target)
    |> fun (a, b) -> a * b

// Step 1 using recursion:

let pairsRec xs =
    let rec inner xs i =
        seq {
            for j = i + 1 to Array.length xs - 1 do
                yield (xs[i], xs[j])

            if i < Array.length xs - 1 then
                yield! inner xs (i + 1)
        }

    inner xs 0

let step1Recursive () : int =
    entries
    |> pairsRec
    |> Seq.find (fun (a, b) -> a + b = target)
    |> fun (a, b) -> a * b

// Step 1 using recursion and pre-sort:

let pairsRecSorted xs =
    let rec inner i j =
        seq {
            if j < Array.length xs && ((xs[i] + xs[j]) <= target) then
                yield (xs[i], xs[j])
                yield! inner i (j + 1)
        }

    seq {
        for i = 0 to Array.length xs - 2 do
            yield! inner i (i + 1)
    }

let step1RecursiveSorted () : int =
    entries
    |> Array.sort
    |> pairsRecSorted
    |> Seq.find (fun (a, b) -> a + b = target)
    |> fun (a, b) -> a * b

// Step 1 using a set:

let step1Set () : int =
    let entrySet = Set.ofArray entries
    let num1 = Array.find (fun i -> entrySet.Contains(target - i)) entries
    num1 * (target - num1)

// Step 2:

let triplets xs =
    seq {
        for i = 0 to Array.length xs - 3 do
            for j = i + 1 to Array.length xs - 2 do
                for k = j + 1 to Array.length xs - 1 do
                    yield (xs[i], xs[j], xs[k])
    }

let step2 () : int =
    entries
    |> triplets
    |> Seq.find (fun (a, b, c) -> a + b + c = target)
    |> fun (a, b, c) -> a * b * c

Utils.benchmark [ ("step1ForLoops", step1ForLoops)
                  ("step1Recursive", step1Recursive)
                  ("step1RecursiveSorted", step1RecursiveSorted)
                  ("step1Set", step1Set)
                  ("step2", step2) ]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1ForLoops        |               542619 |    2 |    2755690 |
| step1Recursive       |               542619 |    1 |    1588433 |
| step1RecursiveSorted |               542619 |    0 |     370589 |
| step1Set             |               542619 |    0 |     521791 |
| step2                |             32858450 |  250 |  250186685 |
*)
