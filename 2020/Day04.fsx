#load "Utils.fsx"

open System.Text.RegularExpressions
open Utils

// Parse input:

let parsePassport (str: string) =
    str.Split(' ', '\n')
    |> Array.map (fun pair ->
        match pair.Split ':' with
        | [| key; value |] -> (key, value)
        | _ -> failwith $"parse error ({pair})")
    |> Map.ofArray

let passports =
    "./input04.txt"
    |> System.IO.File.ReadAllText
    |> (fun input -> input.Split("\n\n", System.StringSplitOptions.TrimEntries))
    |> Array.map parsePassport

// Step 1:

let requiredKeys =
    [| "byr"
       "iyr"
       "eyr"
       "hgt"
       "hcl"
       "ecl"
       "pid" |]

let containsRequiredKeys map =
    requiredKeys
    |> Array.forall (fun key -> Map.containsKey key map)

let step1 () =
    passports
    |> Array.filter containsRequiredKeys
    |> Array.length

// Step 2:

let isIntBetween min max (str: string) =
    match System.Int32.TryParse(str) with
    | (true, year) when min <= year && year <= max -> true
    | _ -> false

let isValidHeight str =
    match str with
    | ParseRegex "^(\d+)cm$" [ _; Int height ] -> 150 <= height && height <= 193
    | ParseRegex "^(\d+)in$" [ _; Int height ] -> 59 <= height && height <= 76
    | _ -> false

let isValidHairColor str = Regex.IsMatch(str, "^#[0-9a-f]{6}$")

let isValidEyeColor str =
    Array.contains
        str
        [| "amb"
           "blu"
           "brn"
           "gry"
           "grn"
           "hzl"
           "oth" |]

let isValidPid str = Regex.IsMatch(str, "^\d{9}$")

let validatorPairs =
    [| ("byr", isIntBetween 1920 2002)
       ("iyr", isIntBetween 2010 2020)
       ("eyr", isIntBetween 2020 2030)
       ("hgt", isValidHeight)
       ("hcl", isValidHairColor)
       ("ecl", isValidEyeColor)
       ("pid", isValidPid) |]

let keysAreValid (map: Map<string, string>) =
    validatorPairs
    |> Array.forall (fun (key, validator) -> validator map[key])

let step2 () =
    passports
    |> Array.filter (fun p -> containsRequiredKeys p && keysAreValid p)
    |> Array.length

benchmark [ ("step1", step1)
            ("step2", step2) ]
