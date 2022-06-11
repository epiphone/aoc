#load "Utils.fsx"

let entries =
    "./input01.txt"
    |> System.IO.File.ReadLines
    |> Seq.map int
    |> Seq.toArray

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
    seq {
        for i = 0 to Array.length xs - 2 do
            let rec inner j =
                seq {
                    if j < Array.length xs && ((xs[i] + xs[j]) <= target) then
                        yield (xs[i], xs[j])
                        yield! inner (j + 1)
                }

            yield! inner (i + 1)
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

Utils.withStopwatch "step1ForLoops" step1ForLoops
Utils.withStopwatch "step1Recursive" step1Recursive
Utils.withStopwatch "step1RecursiveSorted" step1RecursiveSorted
Utils.withStopwatch "step1Set" step1Set
Utils.withStopwatch "step2" step2

// > dotnet fsi Day01.fsx
// step1ForLoops result=542619 took 1ms (1227408 ticks)
// step1Recursive result=542619 took 1ms (1268170 ticks)
// step1RecursiveSorted result=542619 took 1ms (1554993 ticks)
// step1Set result=542619 took 1ms (1795135 ticks)
// step2 result=32858450 took 37ms (37053541 ticks)
