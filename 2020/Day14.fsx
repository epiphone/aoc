#load "./Utils.fsx"

open System.Collections.Generic
open System.Text.RegularExpressions
open Utils

// Parse input:

type Instruction =
    | Mask of string
    | Write of uint64 * uint64

let parseInstruction (line: string) : Instruction =
    if line.StartsWith "mask" then
        Mask line[7..]
    else
        let matches = [ for m in (Regex "\d+").Matches(line) -> m.Value ]
        Write(uint64 matches[0], uint64 matches[1])

let instructions: Instruction [] =
    "./input14.txt"
    |> System.IO.File.ReadAllLines
    |> Array.map parseInstruction

// Step 1:

let maxUInt36 = System.Convert.ToUInt64("111111111111111111111111111111111111", 2)

let setBitAtIndex (input: uint64) (index: int) (value: bool) : uint64 =
    match value with
    | true -> input ||| (1UL <<< index)
    | false -> min maxUInt36 (input &&& ~~~(1UL <<< index))

let applyMask (input: uint64) (mask: string) : uint64 =
    let rec loop (acc: uint64) (i: int) =
        if i = mask.Length then
            acc
        else
            match mask[mask.Length - 1 - i] with
            | '0' -> loop (setBitAtIndex acc i false) (i + 1)
            | '1' -> loop (setBitAtIndex acc i true) (i + 1)
            | _ -> loop acc (i + 1)

    loop input 0

type Program =
    { Memory: Dictionary<uint64, uint64>
      mutable Mask: string }

    static member Default() : Program = { Memory = Dictionary(); Mask = "" }

    member this.ApplyInstruction(instruction: Instruction) : unit =
        match instruction with
        | Mask mask -> this.Mask <- mask
        | Write (addr, value) -> this.Memory[ addr ] <- applyMask value this.Mask

    member this.ApplyInstructions(instructions: Instruction []) : unit =
        Array.iter this.ApplyInstruction instructions

let step1 () =
    let program = Program.Default()

    program.ApplyInstructions instructions

    program.Memory.Values |> Seq.sum

// Step 2:

// TODO check for str library function
let combinations (length: int) (xs: list<'a>) : list<list<'a>> =
    let rec loop (acc: list<'a>) (i: int) : list<list<'a>> =
        if i = length then
            [ acc ]
        else
            xs
            |> List.collect (fun x -> loop (x :: acc) (i + 1))

    loop [] 0

let getFloatingMaskPermutations (mask: string) : list<string> =
    let floatingIndexes =
        mask
        |> Seq.toArray
        |> Array.mapi (fun i c -> (i, c))
        |> Array.filter (fun (_, c) -> c = 'X')
        |> Array.map fst

    let maskPermutation = System.Text.StringBuilder(mask.Replace('0', 'X'))

    combinations floatingIndexes.Length [ '0'; '1' ]
    |> List.map (fun floatingValues ->

        for i = 0 to floatingValues.Length - 1 do
            maskPermutation[floatingIndexes[i]] <- floatingValues[i]

        maskPermutation.ToString())

type ProgramV2 =
    { Memory: Dictionary<uint64, uint64>
      mutable Masks: list<string> }

    static member Default() : ProgramV2 = { Memory = Dictionary(); Masks = [] }

    member this.ApplyInstruction(instruction: Instruction) : unit =
        match instruction with
        | Mask mask -> this.Masks <- getFloatingMaskPermutations mask
        | Write (addr, value) ->
            this.Masks
            |> List.iter (fun mask -> this.Memory[ applyMask addr mask ] <- value)

    member this.ApplyInstructions(instructions: Instruction []) : unit =
        Array.iter this.ApplyInstruction instructions

let step2 () =
    let program = ProgramV2.Default()

    program.ApplyInstructions instructions

    program.Memory.Values |> Seq.sum

benchmark [| "step1", step1
             "step2", step2 |]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1                |        6559449933360 |    0 |     755914 |
| step2                |        3369767240513 |  199 |  199095015 |
*)
