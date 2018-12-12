import sequtils, strformat, strutils, tables
from times import epochTime


type Pots = array[5, bool]

func parse_pots(pots: string): Pots =
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

proc to_string(pots: seq[bool]): string =
  result = newStringOfCap(pots.len)
  for p in pots:
    result.add(if p: '#' else: '.')

proc step1(): int =
  let (initial_pots, rules) = read_input()
  let padding = repeat(false, 20)
  var pots = padding & initial_pots & padding
  # echo to_string(pots)


  # for t in 1..1_000_000:
  for t in 1..20:
    var new_pots: seq[bool] = pots[0..<2]
    var curr = 0 #bool_arr_to_int(pots[0..<5])
    for i, pot in pots[2..^1]:
      let real_i = i + 2
      if real_i > (pots.high - 2):
        new_pots.add(pot)
        continue

      if curr >= 16:
        curr -= 16
      curr = curr shl 1
      curr += int8(pot)

      let key = bool_arr_to_int(pots[real_i - 2..real_i + 2])
      # echo &"i:{i} key:{key} curr:{curr}"
      # assert curr == key, &"i:{i} curr:{curr} key:{key}"
      let rule_output = rules[key]
      new_pots.add(rule_output)

    assert pots.len == new_pots.len
    pots = new_pots
    # echo to_string(pots)

  for i, p in pots:
    if p:
      result += i - 20


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
