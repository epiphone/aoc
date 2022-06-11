let withStopwatch name fn =
    let stopwatch = System.Diagnostics.Stopwatch.StartNew()
    let result = fn ()
    stopwatch.Stop()
    printfn $"{name} result={result} took {stopwatch.ElapsedMilliseconds}ms ({stopwatch.ElapsedTicks} ticks)"
