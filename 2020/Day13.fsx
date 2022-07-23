#load "./Utils.fsx"

open Utils

// Parse input:

let (departureTimestamp, busIds): int * array<int> =
    "./input13.txt"
    |> System.IO.File.ReadAllLines
    |> (fun lines ->
        (int lines[0],
         lines[ 1 ].Split(',')
         |> Array.map (fun str -> if str = "x" then 0 else int str)))

// Step 1:

let nearestDepartureAt (target: int) (busId: int) : int = (target / busId) * busId + busId

let step1 () =
    let validBusIds = busIds |> Array.filter (fun busId -> busId <> 0)
    let busId = Array.minBy (nearestDepartureAt departureTimestamp) validBusIds

    busId
    * ((nearestDepartureAt departureTimestamp busId)
       - departureTimestamp)

// Step 2:

let consecutiveMatchingBuses (timestamp: int64) (busIds: array<int>) : int =
    let rec loop i acc =
        if i = busIds.Length then
            acc
        else if busIds[i] = 0 then
            loop (i + 1) acc
        else if (timestamp + (int64 i)) % (int64 busIds[i]) = 0 then
            loop (i + 1) (acc + 1)
        else
            acc

    loop 0 0

let earliestOffsettingTimestamp (busIds: array<int>) : int64 =
    let busCount =
        busIds
        |> Array.filter (fun n -> n <> 0)
        |> Array.length

    let prevTimestamps = [| for i in 0..busCount -> 0L |]

    let rec loop timestamp step =
        match consecutiveMatchingBuses timestamp busIds with
        | n when n = busCount -> timestamp
        | 0 -> loop (timestamp + step) step
        | n ->
            let newStep =
                if prevTimestamps[n] <> 0 then
                    max step (timestamp - prevTimestamps[n])
                else
                    step

            prevTimestamps[n] <- timestamp

            loop (timestamp + newStep) newStep

    loop busIds[0] busIds[0]

// Really struggled with step 2, had to peek from https://www.reddit.com/r/adventofcode/comments/kc4njx/comment/gktms17
let step2 () = earliestOffsettingTimestamp busIds

benchmark [| "step1", step1 >> int64
             "step2", step2 |]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1                |                 2215 |    0 |       5234 |
| step2                |     1058443396696792 |    0 |     979594 |
*)
