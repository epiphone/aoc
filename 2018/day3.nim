from tables import nil
from re import nil
from strUtils import parseInt
from times import cpuTime

proc step1(): int =
  var grid: array[1000*1000, int]

  for line in lines("day3input.txt"):
    var matches: array[5, string]
    discard re.match(line, re.re"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)", matches)
    let
      x = parseInt(matches[1])
      y = parseInt(matches[2])
      w = parseInt(matches[3])
      h = parseInt(matches[4])

    for i in 0..<h:
      for j in 0..<w:
        let grid_index = 1000 * (y + i) + x + j
        inc(grid[grid_index])

  var overlap_count = 0
  for v in grid:
    if v >= 2:
      inc(overlap_count)
  return overlap_count

proc step1_hashset(): int =
  type GridKey = array[0..1, int]
  let grid = tables.newCountTable[GridKey]()
  let input_f = open("day3input.txt")
  defer: close(input_f)
  for line in input_f.lines:
    var matches: array[5, string]
    discard re.match(line, re.re"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)", matches)
    let
      x = parseInt(matches[1])
      y = parseInt(matches[2])
      w = parseInt(matches[3])
      h = parseInt(matches[4])

    for i in 0..<h:
      for j in 0..<w:
        tables.inc(grid, [x + j, y + i])

  var overlap_count = 0
  for v in tables.values(grid):
    if v >= 2:
      inc(overlap_count)
  return overlap_count


proc step2(): int =
  var grid: array[1000*1000, int]
  var claims: seq[array[5, int]] = @[]
  let input_f = open("day3input.txt")
  defer: close(input_f)
  for line in input_f.lines:
    var matches: array[5, string]
    discard re.match(line, re.re"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)", matches)
    let
      id = parseInt(matches[0])
      x = parseInt(matches[1])
      y = parseInt(matches[2])
      w = parseInt(matches[3])
      h = parseInt(matches[4])

    for i in 0..<h:
      for j in 0..<w:
        let grid_index = 1000 * (y + i) + x + j
        inc(grid[grid_index])
    claims.add([id, x, y, w, h])

  for claim in claims:
    block claim_block:
      for i in claim[2]..<claim[2] + claim[4]:
        for j in claim[1]..<claim[1] + claim[3]:
          let grid_index = 1000 * i + j
          if grid[grid_index] > 1:
            break claim_block
      return claim[0]

when isMainModule:
  var time = cpuTime()
  echo "Step 1: ", step1(), ", took ", (cpuTime() - time) * 1000, " ms"
  echo "Step 1 hashset: ", step1_hashset(), ", took ", (cpuTime() - time) * 1000, " ms"
  echo "Step 2: ", step2(), ", took ", (cpuTime() - time) * 1000, " ms"
