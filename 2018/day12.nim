import sequtils, strformat, strutils, tables
from times import epochTime


func parse_pots(pots: string): array[5, bool] =
  for i, c in pots:
    result[i] = c == '#'

func bool_arr_to_int*(bools: openArray[bool]): int8 =
  for i, b in bools:
    result = cast[int8]((result shl 1) + int(b))

proc read_input(): (seq[bool], array[32, bool]) =
  for line in lines("inputs/day12.txt"):
    if result[0].len == 0:
      for c in line.split()[^1]:
        result[0].add(c == '#')
    elif line != "":
      let parts = line.split(" => ")
      let key = parts[0].parse_pots().bool_arr_to_int()
      result[1][key] = parts[1] == "#"

proc step1(): int =
  let (initial_pots, rules) = read_input()
  var
    pots = initial_pots
    head = 0

  for t in 1..20:
    var new_pots: seq[bool] = @[]
    var curr: int8 = 0
    for i, pot in pots & repeat(false, 3):
      if curr >= 16:
        curr -= 16
      curr = curr shl 1
      curr += int8(pot)

      let new_pot = rules[curr]
      if new_pot and new_pots.len() == 0:
        head = head + i - 2
      if not new_pot and new_pots.len() == 0:
        continue
      new_pots.add(new_pot)

    pots = new_pots

  for i, p in pots:
    if p:
      result += i + head


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
