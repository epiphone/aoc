let withStopwatch name fn =
    fn () |> ignore // warm up
    let stopwatch = System.Diagnostics.Stopwatch.StartNew()
    let result = fn ()

    // repeat a few times:
    for _ = 1 to 9 do
        fn () |> ignore

    stopwatch.Stop()

    printfn "| %-20s | %20O | %4d | %10d |" name result stopwatch.ElapsedMilliseconds stopwatch.ElapsedTicks

let benchmark (entries: seq<string * (unit -> 'a)>) : unit =
    printfn "| name                 |               result |   ms |      ticks |"
    printfn "|=================================================================|"

    for (name, fn) in entries do
        withStopwatch name fn
