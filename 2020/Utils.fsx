open System.Text.RegularExpressions

// Benchmarking:

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

// Input parsing:

let makeRegex (input: obj) =
    match input with
    | :? string as str -> Regex(str)
    | :? Regex as regex -> regex
    | _ -> failwith "invalid regex"

let matches regexStr (input: string) =
    let m = makeRegex(regexStr).Match(input)

    if m.Success then
        Some [ for group in m.Groups -> group.Value ]
    else
        None

let (|ParseRegex|_|) regex str = matches regex str

let (|Int|_|) (str: string) =
    match System.Int32.TryParse str with
    | (true, int) -> Some int
    | _ -> None

let (|Char|_|) (str: string) =
    if str.Length = 1 then
        Some str[0]
    else
        None

// Other:

let memoize (fn: 'a -> 'b) : 'a -> 'b =
    let cache = System.Collections.Generic.Dictionary<'a, 'b>()

    fun x ->
        match cache.TryGetValue(x) with
        | (true, res) -> res
        | _ ->
            let res = fn x
            cache.Add(x, res)
            res
