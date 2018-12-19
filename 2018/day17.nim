import queues, sequtils, sets, strformat, strscans, strutils
from times import epochTime


type
  Tile = enum sand, clay, flowing_water, water_at_rest
  Point = tuple[x, y: int]


proc read_input(): (Point, seq[seq[Tile]]) =
  var points = initSet[Point]()
  for line in lines("inputs/day17.txt"):
    let parts = line.split()
    var x, x_from, x_to, y, y_from, y_to: int
    if scanf(parts[1], "x=$i..$i", x_from, x_to):
      discard scanf(parts[0], "y=$i", y)
      for i in countup(x_from, x_to):
        points.incl((i, y))
    else:
      discard scanf(parts[0], "x=$i", x)
      discard scanf(parts[1], "y=$i..$i", y_from, y_to)
      for i in countup(y_from, y_to):
        points.incl((x, i))

  let first_point = toSeq(points.items)[0]
  var min_x, max_x = first_point.x
  var max_y = first_point.y
  for x, y in points.items:
    min_x = min(min_x, x)
    max_x = max(max_x, x)
    max_y = max(max_y, y)
  result[0] = (501 - min_x, 0)

  for y in 0..max_y:
    var row = @[sand, sand]
    for x in min_x..max_x:
      row.add(if (x, y) in points: clay else: sand)
    row.add(sand)
    row.add(sand)
    result[1].add(row)


proc step1(): int =
  var (spring, grid) = read_input()
  let max_y = len(grid)

  var spills = initQueue[Point]()
  spills.enqueue(spring)

  while len(spills) > 0:
    var (x, y) = spills.dequeue()
    let spills_n = len(spills)

    # 1. Flow down until hits clay, water_at_rest or y > max_y
    while y < max_y - 1 and grid[y + 1][x] == sand:
      y.inc()
      if grid[y][x] == sand: result.inc()
      grid[y][x] = flowing_water
    if y == max_y - 1:
      continue
    if grid[y + 1][x] == flowing_water:
      continue

    # 2. Fill horizontal layers until either side spills over
    while true:
      var left, right = x
      var spilled = false
      while grid[y][left - 1] in {sand, flowing_water, water_at_rest}:
        left.dec()
        if grid[y][left] == sand: result.inc()
        grid[y][left] = water_at_rest
        if grid[y + 1][left] in {sand, flowing_water}:
          grid[y][left] = flowing_water
          if not ((left, y) in spills): spills.enqueue((left, y))
          spilled = true
          break
      while grid[y][right + 1] in {sand, flowing_water, water_at_rest}:
        right.inc()
        if grid[y][right] == sand: result.inc()
        grid[y][right] = water_at_rest
        if grid[y + 1][right] in {sand, flowing_water}:
          grid[y][right] = flowing_water
          if not ((right, y) in spills): spills.enqueue((right, y))
          spilled = true
          break

      if spilled:
        for flow_x in left..right:
          grid[y][flow_x] = flowing_water
        break
      grid[y][x] = water_at_rest
      y.dec()

  var min_y = 999
  for y, row in grid:
    if clay in row:
      min_y = y
      break
  echo "min_y: ", min_y

  result = 0
  for y, row in grid:
    if y < min_y:
      continue
    for grid in row:
      if grid in {flowing_water, water_at_rest}:  # <-- step 1
      # if grid == water_at_rest:                 # <-- step 2
        result.inc()

when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
