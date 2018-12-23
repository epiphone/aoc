import algorithm, strformat, strscans
from times import epochTime

type Nanobot = tuple[x, y, z, r : int]


proc read_input(): seq[Nanobot] =
  for line in lines("inputs/day23.txt"):
    discard
    var x, y, z,r: int
    discard scanf(line, "pos=<$i,$i,$i>, r=$i", x, y, z, r)
    result.add((x, y, z, r))


func manhattan_distance(a: Nanobot, b: Nanobot): int =
  return abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z)


proc step1(): int =
  let input = read_input()
  let max_bot = input.sortedByIt(it.r)[^1]

  for bot in input:
    if manhattan_distance(bot, max_bot) > max_bot.r:
      continue
    else:
      result.inc()


proc step2(): int =
  #[
    Brute force solution that searches for an optimal coordinate starting from
    step 1's result. Scanning initially with `mult=10_000` and progressively
    lowering the value, resetting `top_coord` and `result` whenever a more
    optimal coordinate was found.
  ]#
  let input = read_input()
  var top_coord = (x: 35689633, y: 18108021, z: 46676372, r: 0)
  var dist = manhattan_distance((0,0,0,0), top_coord)
  var mult = 1
  result = 926

  for x in -50..50:
    for y in -50..50:
      for z in -50..50:
        var
          coord = ((x * mult + top_coord.x, y * mult + top_coord.y, z * mult + top_coord.z, 0))
          coord_dist = manhattan_distance((0, 0, 0, 0), coord)
          bots_in_range = 0

        for bot in input:
          if manhattan_distance(coord, bot) <= bot.r:
            bots_in_range.inc()

        if bots_in_range > result or (bots_in_range == result and coord_dist < dist):
          dist = coord_dist
          result = bots_in_range
          top_coord = coord

  return manhattan_distance((0, 0, 0, 0), top_coord)


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
