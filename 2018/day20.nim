import strformat, sets, tables
from times import epochTime


type Point = tuple[x, y: int]

proc read_input(): string =
  for line in lines("inputs/day20.txt"):
    return line

proc steps1_and_2(): int =
  let instructions = read_input()
  var map = initTable[Point, HashSet[Point]]()

  proc parse(next: int, start_from: Point): tuple[next: int, ps: seq[Point]] =
    var i = next
    result.ps.add(start_from)

    while true:
      var move: Point = (0, 0)
      case instructions[i]
      of '$', ')':
        return (i + 1, result.ps)
      of 'N':
        move = (0, -1)
      of 'S':
        move = (0, 1)
      of 'W':
        move = (-1, 0)
      of 'E':
        move = (1, 0)
      of '|':
        result.ps.add(start_from)
      of '(':
        let (new_i, new_ps) = parse(i + 1, result.ps.pop())
        for p in new_ps:
          result.ps.add(p)
        i = new_i
        continue
      else:
        discard

      if move != (0, 0):
        let prev = result.ps[^1]
        result.ps[^1] = (prev.x + move.x, prev.y + move.y)
        if not (prev in map):
          map[prev] = initSet[Point]()
        map[prev].incl(result.ps[^1])

      i.inc()

  discard parse(0, (0, 0))

  var dists = newCountTable[Point]()
  proc calculate_dists(p: Point, steps_taken: int, visited: HashSet[Point]) =
    let new_visited = union(visited, toSet([p]))
    if steps_taken >= 1000:
      if not (p in dists):
        dists[p] = steps_taken
      else:
        dists[p] = min(dists[p], steps_taken)

    if p in map:
      for neighbour in map[p]:
        if not (neighbour in visited):
          calculate_dists(neighbour, steps_taken + 1, new_visited)

  calculate_dists((0, 0), 0, initSet[Point]())

  # Step 1:
  # return dists.largest[1]

  # Step2:
  for _, dist in dists:
    if dist >= 1000:
      result.inc()


when isMainModule:
  var t0 = epochTime()
  echo &"Steps 1 and 2: {steps1_and_2()}, took {(epochTime() - t0) * 1000:3} ms"
