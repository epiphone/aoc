#load "./Utils.fsx"

open Utils

// Parse input:

let adapters: int [] =
    "./input10.txt"
    |> System.IO.File.ReadAllLines
    |> Array.map int

// Step 1:

let countJoltDifferences (adapterChain: int []) =
    let rec loop i diff1s diff3s =
        if i = adapterChain.Length then
            (diff1s, diff3s + 1)
        else
            match adapterChain[i] - adapterChain[i - 1] with
            | 1 -> loop (i + 1) (diff1s + 1) diff3s
            | 3 -> loop (i + 1) diff1s (diff3s + 1)
            | diff -> failwith $"got diff of {diff} between {adapterChain[i]} and {adapterChain[i - 1]}"

    loop 1 0 0

let step1 () =
    adapters
    |> Array.sort
    |> Array.append [| 0 |]
    |> countJoltDifferences
    |> (fun (diff1s, diff3s) -> (diff1s * diff3s) |> int64)

// Step 2:

let validAdapters (source: int) (adapters: Set<int>) : seq<int> =
    seq {
        for i in 1..3 do
            if adapters.Contains(source + i) then
                yield source + i
    }

let adapterChainPermutationsCount adapters =
    let maxAdapter = adapters |> Set.maxElement

    let rec loop (source: int) : int64 =
        if source = maxAdapter then
            1
        else
            validAdapters source adapters
            |> Seq.sumBy (fun a -> memoizedLoop a)

    and memoizedLoop = memoize loop

    memoizedLoop 0

let step2 () =
    adapters
    |> Set.ofArray
    |> adapterChainPermutationsCount

// Step 2 backwards (got the idea from https://github.com/lizthegrey/adventofcode/blob/main/2020/day10.go):

let step2Rev () =
    let adpts = adapters |> Array.sort

    let rec loop i tail =
        if i < 0 then
            Array.sum tail
        else
            let mutable sum = 0L

            for j = 1 to 3 do
                if (i + j) < adpts.Length
                   && adpts[i + j] - adpts[i] <= 3 then
                    sum <- sum + tail[j - 1]

            loop (i - 1) [| sum; tail[0]; tail[1] |]

    loop (adapters.Length - 2) [| 1L; 1L; 1L |]


benchmark [| ("step1", step1)
             ("step2", step2)
             ("step2Rev", step2Rev) |]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1                |                 2100 |    0 |      25206 |
| step2                |       16198260678656 |    0 |     480532 |
| step2Rev             |       16198260678656 |    0 |      25793 |
*)
