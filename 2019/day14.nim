import math, strutils, tables

type Reaction = tuple
  inputs: Table[string, int]
  output_element: string
  output_count: int

proc read_input(): Table[string, Reaction] =
  for line in lines("./input14.txt"):
    var reaction: Reaction
    let
      parts = line.split(" => ")
      output_parts = parts[1].split(' ')

    reaction.output_element = output_parts[1]
    reaction.output_count = parseInt(output_parts[0])

    for input in parts[0].split(", "):
      let input_parts = input.split(' ')
      reaction.inputs[input_parts[1]] = parseInt(input_parts[0])

    result[reaction.output_element] = reaction


proc step1(fuel_needed = 1): int =
  let reactions = read_input()
  var
    reqs = initTable[string, int]()
    overflow = initTable[string, int]()

  proc ore_needed(element: string, count: int) =
    let
      reaction = reactions[element]
      needed = max(0, count - overflow.mgetOrPut(element, 0))
      num_of_reactions = ceil(needed / reaction.output_count).int

    overflow[element] = max(0, overflow[element] - count)

    if "ORE" in reaction.inputs:
      reqs[element] = reqs.getOrDefault(element) + count
    overflow[element] += num_of_reactions * reaction.output_count - needed

    for input_el, input_count in reaction.inputs.pairs:
      if input_el != "ORE":
        ore_needed(input_el, input_count * num_of_reactions)

  ore_needed("FUEL", fuel_needed)

  for el, count in reqs:
    let reaction = reactions[el]
    result += reaction.inputs["ORE"] * ceil(count / reaction.output_count).int


proc step2(): int =
  var i, j, k: int
  while true:
    if step1(i) > 1_000_000_000_000:
      i -= 10_000
      while true:
        if step1(i + j) > 1_000_000_000_000:
          j -= 100
          while true:
            if step1(i + j + k) > 1_000_000_000_000:
              return i + j + k - 1
            k += 1
        j += 100
    i += 10_000


when isMainModule:
  echo "Step 1: ", step1()
  echo "Step 2: ", step2()



