#load "Utils.fsx"

open Utils

type Instruction =
    | Nop of int
    | Acc of int
    | Jmp of int

    static member ofString(str: string) =
        match str.Split(' ') with
        | [| "nop"; arg |] -> Nop(int arg)
        | [| "acc"; arg |] -> Acc(int arg)
        | [| "jmp"; arg |] -> Jmp(int arg)
        | _ -> failwith $"Cannot parse instruction {str}"

    member this.ToString =
        match this with
        | Nop arg -> $"nop {arg}"
        | Jmp arg -> $"jmp {arg}"
        | Acc arg -> $"acc {arg}"

type Computer =
    { Instructions: Instruction []
      Index: int
      Acc: int }

    static member Default instructions =
        { Instructions = instructions
          Acc = 0
          Index = 0 }

    member this.Tick: Computer =
        match this.Instructions[this.Index] with
        | Nop _ -> { this with Index = this.Index + 1 }
        | Acc arg ->
            { this with
                Index = this.Index + 1
                Acc = this.Acc + arg }
        | Jmp arg -> { this with Index = this.Index + arg }

    /// jepa
    member this.Terminating: bool = this.Index = this.Instructions.Length - 1

let instructions =
    "./input08.txt"
    |> System.IO.File.ReadAllLines
    |> Array.map Instruction.ofString

// Step 1:

let tickUntilLoop (cmp: Computer) : Computer =
    let rec loop (currCmp: Computer) (visitedIndexes: Set<int>) =
        match currCmp.Tick with
        | nextCmp when visitedIndexes.Contains nextCmp.Index -> nextCmp
        | nextCmp -> loop nextCmp (visitedIndexes.Add nextCmp.Index)

    loop cmp Set.empty

let step1 () =
    instructions
    |> Computer.Default
    |> tickUntilLoop
    |> (fun cmp -> cmp.Acc)

// Step 2:

let tickUntilLoopOrTerminate (cmp: Computer) : Computer =
    let rec loop (currCmp: Computer) (visitedIndexes: Set<int>) =
        match currCmp.Tick with
        | nextCmp when nextCmp.Terminating -> nextCmp
        | nextCmp when visitedIndexes.Contains nextCmp.Index -> nextCmp
        | nextCmp -> loop nextCmp (visitedIndexes.Add nextCmp.Index)

    loop cmp Set.empty

let tickUntilTerminating (cmp: Computer) : option<Computer> =
    let rec loop (currCmp: Computer) (visitedIndexes: Set<int>) =
        match currCmp.Tick with
        | nextCmp when nextCmp.Terminating -> Some nextCmp
        | nextCmp when visitedIndexes.Contains nextCmp.Index -> None
        | nextCmp -> loop nextCmp (visitedIndexes.Add nextCmp.Index)

    loop cmp Set.empty

let instructionPermutations (instructions: Instruction []) : seq<Instruction []> =
    seq {
        for i = 0 to instructions.Length - 1 do
            let changedInstruction =
                match instructions[i] with
                | Nop arg -> Some(Jmp arg)
                | Jmp arg -> Some(Nop arg)
                | _ -> None

            if Option.isSome changedInstruction then
                let originalInstruction = instructions[i]
                instructions.SetValue(changedInstruction.Value, i)
                yield instructions
                instructions.SetValue(originalInstruction, i)
    }

let tweakInstructionsUntilTerminate (instructions: Instruction []) =
    instructions
    |> instructionPermutations
    |> Seq.map (fun insts -> insts |> Computer.Default |> tickUntilTerminating)
    |> Seq.pick id

let step2 () =
    instructions
    |> tweakInstructionsUntilTerminate
    |> (fun cmp -> cmp.Tick.Acc)

benchmark [| ("step1", step1)
             ("step2", step2) |]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1                |                 1584 |    0 |     636188 |
| step2                |                  920 |    0 |     650033 |
*)
