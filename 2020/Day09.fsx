#load "Utils.fsx"

open Utils

// Parse input:

let cipher: int64 [] =
    "./input09.txt"
    |> System.IO.File.ReadAllLines
    |> Array.map int64

// Step 1:

let inline findIndexPair (pred: int * int -> bool) (xs: int64 []) =
    let rec loop i j =
        if i = xs.Length - 1 then
            None
        else if j = xs.Length then
            loop (i + 1) (i + 2)
        else if pred (i, j) then
            Some(i, j)
        else
            loop i (j + 1)

    loop 0 1

let isSumOf (nums: int64 []) (target: int64) =
    match findIndexPair (fun (i, j) -> nums[i] + nums[j] = target) nums with
    | Some _ -> true
    | _ -> false

let findBreakingNumber (nums: int64 []) (preambleLen: int) =
    let rec loop i =
        if isSumOf nums[i - preambleLen .. i - 1] nums[i] then
            loop (i + 1)
        else
            nums[i]

    loop preambleLen

let step1 () = findBreakingNumber cipher 25

// Step 2:

let sumBetweenIndexes (xs: int64 []) i1 i2 =
    let rec loop acc i =
        if i > i2 then
            acc
        else
            loop (acc + xs[i]) (i + 1)

    loop 0 i1

let findContiguousRangeAddingUpTo (xs: int64 []) (target: int64) : int64 [] =
    let rec loop i j =
        let sum = sumBetweenIndexes xs i j

        if i = j then loop (i + 1) (i + 2)
        else if sum < target then loop i (j + 1)
        else if sum > target then loop (i + 1) j
        else xs[i..j]

    loop 0 1

let step2 () =
    let range = findContiguousRangeAddingUpTo cipher 1639024365
    (Array.min range) + (Array.max range)

// Step 2 with an accumulator:

let findContiguousRangeAddingUpToAcc (xs: int64 []) (target: int64) : int64 [] =
    let rec loop acc i j =
        if i = j then
            loop (xs[i + 1] + xs[i + 2]) (i + 1) (i + 2)
        else if acc < target then
            loop (acc + xs[j + 1]) i (j + 1)
        else if acc > target then
            loop (acc - xs[i]) (i + 1) j
        else
            xs[i..j]

    loop (xs[0] + xs[1]) 0 1

let step2Acc () =
    let range = findContiguousRangeAddingUpToAcc cipher 1639024365
    (Array.min range) + (Array.max range)

benchmark [| ("step1", step1)
             ("step2", step2)
             ("step2Acc", step2Acc) |]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1                |           1639024365 |    2 |    2070121 |
| step2                |            219202240 |    1 |    1640268 |
| step2Acc             |            219202240 |    0 |      13296 |
*)
