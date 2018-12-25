import algorithm, strformat, strscans
from times import epochTime


type Constellation = tuple[x, y, z, t: int]


proc read_input(): seq[Constellation] =
  for line in lines("inputs/day25.txt"):
    var x, y, z, t: int
    discard scanf(line, "$i,$i,$i,$i", x, y, z, t)
    result.add((x, y, z, t))


func manhattan_distance(a: Constellation, b: Constellation): int =
  return abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z) + abs(a.t - b.t)


proc step1(): int =
  let input = read_input()
  var cs: seq[seq[Constellation]] = @[]

  for i, row in input:
    var belongs_to: seq[int]

    for j, c_group in cs:
      for c in c_group:
        if manhattan_distance(row, c) <= 3:
          belongs_to.add(j)
          break

    if len(belongs_to) == 0:
      cs.add(@[row])
    else:
      cs[belongs_to[0]].add(row)
      for index in belongs_to[1..^1].reversed():
        cs[belongs_to[0]] &= cs[index]
        cs.del(index)

  return len(cs)


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
