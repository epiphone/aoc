#load "Utils.fsx"

open Utils

// Parse input:

type Instruction =
    | Nop of int
    | Acc of int
    | Jmp of int

    member this.ToString =
        match this with
        | Nop arg -> $"nop {arg}"
        | Jmp arg -> $"jmp {arg}"
        | Acc arg -> $"acc {arg}"

let parseInstruction (str: string) : Instruction =
    match str.Split(' ') with
    | [| "nop"; arg |] -> Nop(int arg)
    | [| "acc"; arg |] -> Acc(int arg)
    | [| "jmp"; arg |] -> Jmp(int arg)
    | _ -> failwith $"Cannot parse instruction {str}"

let instructions =
    "./input08.txt"
    |> System.IO.File.ReadAllLines
    |> Array.map parseInstruction

// Step 1:

type Computer =
    { Instructions: Instruction []
      Index: int
      Acc: int }

    static member Default instructions =
        { Instructions = instructions
          Acc = 0
          Index = 0 }

let tick (cmp: Computer) : Computer =
    match cmp.Instructions[cmp.Index] with
    | Nop _ -> { cmp with Index = cmp.Index + 1 }
    | Acc arg ->
        { cmp with
            Index = cmp.Index + 1
            Acc = cmp.Acc + arg }
    | Jmp arg -> { cmp with Index = cmp.Index + arg }

let tickUntilLoop (cmp: Computer) : Computer =
    let rec loop currCmp visitedIndexes =
        match tick currCmp with
        | cmp when Set.contains cmp.Index visitedIndexes -> cmp
        | cmp -> loop cmp (Set.add cmp.Index visitedIndexes)

    loop cmp (set [])

let step1 () =
    instructions
    |> Computer.Default
    |> tickUntilLoop
    |> (fun cmp -> cmp.Acc)

// Step 2:

let terminated (cmp: Computer) : bool = cmp.Index = cmp.Instructions.Length - 1

let tickUntilLoopOrTerminate (cmp: Computer) : Computer =
    let rec loop currCmp visitedIndexes =
        match tick currCmp with
        | cmp when terminated cmp -> cmp
        | cmp when Set.contains cmp.Index visitedIndexes -> cmp
        | cmp -> loop cmp (Set.add cmp.Index visitedIndexes)

    loop cmp (set [])

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
                Array.set instructions i (Option.get changedInstruction)
                yield instructions
                Array.set instructions i originalInstruction
    }

let tweakInstructionsUntilTerminate (instructions: Instruction []) : Computer =
    instructions
    |> instructionPermutations
    |> Seq.map (fun insts ->
        insts
        |> Computer.Default
        |> tickUntilLoopOrTerminate)
    |> Seq.find terminated

let step2 () =
    instructions
    |> tweakInstructionsUntilTerminate
    |> (fun cmp -> (tick cmp).Acc)

benchmark [| ("step1", step1)
             ("step2", step2) |]

(*
| name                 |               result |   ms |      ticks |
|=================================================================|
| step1                |                 1584 |    0 |     636188 |
| step2                |                  920 |    0 |     650033 |
*)
