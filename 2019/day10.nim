import algorithm, math, sequtils, sets, strutils, tables

let raw_input = """.#....#.###.........#..##.###.#.....##...
...........##.......#.#...#...#..#....#..
...#....##..##.......#..........###..#...
....#....####......#..#.#........#.......
...............##..#....#...##..#...#..#.
..#....#....#..#.....#.#......#..#...#...
.....#.#....#.#...##.........#...#.......
#...##.#.#...#.......#....#........#.....
....##........#....#..........#.......#..
..##..........##.....#....#.........#....
...#..##......#..#.#.#...#...............
..#.##.........#...#.#.....#........#....
#.#.#.#......#.#...##...#.........##....#
.#....#..#.....#.#......##.##...#.......#
..#..##.....#..#.........#...##.....#..#.
##.#...#.#.#.#.#.#.........#..#...#.##...
.#.....#......##..#.#..#....#....#####...
........#...##...#.....#.......#....#.#.#
#......#..#..#.#.#....##..#......###.....
............#..#.#.#....#.....##..#......
...#.#.....#..#.......#..#.#............#
.#.#.....#..##.....#..#..............#...
.#.#....##.....#......##..#...#......#...
.......#..........#.###....#.#...##.#....
.....##.#..#.....#.#.#......#...##..#.#..
.#....#...#.#.#.......##.#.........#.#...
##.........#............#.#......#....#..
.#......#.............#.#......#.........
.......#...##........#...##......#....#..
#..#.....#.#...##.#.#......##...#.#..#...
#....##...#.#........#..........##.......
..#.#.....#.....###.#..#.........#......#
......##.#...#.#..#..#.##..............#.
.......##.#..#.#.............#..#.#......
...#....##.##..#..#..#.....#...##.#......
#....#..#.#....#...###...#.#.......#.....
.#..#...#......##.#..#..#........#....#..
..#.##.#...#......###.....#.#........##..
#.##.###.........#...##.....#..#....#.#..
..........#...#..##..#..##....#.........#
..#..#....###..........##..#...#...#..#.."""

type Point = (int, int)

proc read_input(): seq[seq[bool]] =
  for line in raw_input.splitLines():
    var row: seq[bool]
    for c in line:
      row.add(c == '#')
    result.add(row)

func smallest_submove(point: Point): Point =
  let (a, b) = point
  var divider = 1
  while divider <= min(abs(a), abs(b)):
    if (a mod divider == 0) and (b mod divider == 0):
      result = (a div divider, b div divider)
    divider += 1

func manhattan_distance*(a, b: Point): int =
  abs(a[0] - b[0]) + abs(a[1] - b[1])

proc step1(): int =
  let input = read_input()
  var
    asteroids: seq[(int, int)]
    station: Point

  for y, row in input.pairs:
    for x, asteroid in row.pairs:
      if asteroid:
        asteroids.add((x, y))

  for asteroid in asteroids:
    var can_see = 0

    for target in asteroids:
      if asteroid[0] == target[0] and asteroid[1] == target[1]:
        continue

      let step = smallest_submove((target[0] - asteroid[0], target[1] - asteroid[1]))
      var at = asteroid

      while true:
        at[0] += step[0]
        at[1] += step[1]

        if at == target:
          can_see += 1
          break
        if at in asteroids:
          break
        if manhattan_distance(asteroid, at) > manhattan_distance(asteroid, target):
          break

    if can_see > result:
      result = can_see
      station = asteroid


func angle_between*(a, b: Point): float =
  ## 0 degrees at 12 o'clock
  result = radToDeg(arctan2(b[1].toFloat - a[1].toFloat, b[0].toFloat - a[0].toFloat)) + 90.0
  if result < 0.0:
    result += 360.0

proc step2(): int =
  let
    station = (28, 29)
    input = read_input()

  var
    asteroids = initHashSet[Point]()
    angles = initTable[Point, float]()
    distances = initTable[Point, int]()

  for y, row in input.pairs:
    for x, asteroid in row.pairs:
      if asteroid and (x, y) != station:
        asteroids.incl((x, y))
        angles[(x, y)] = angle_between(station, (x, y))
        distances[(x, y)] = manhattan_distance(station, (x, y))

  var
    sorted_asteroids = sortedByIt(asteroids.toSeq(), (angles[it], distances[it]))
    destroyed_n = 0

  while asteroids.len > 0:
    var prev_angle = -1.0

    for a in sorted_asteroids:
      if not (a in asteroids) or angles[a] <= prev_angle:
        continue

      prev_angle = angles[a]
      asteroids.excl(a)
      destroyed_n += 1

      if destroyed_n == 200:
        return a[0] * 100 + a[1]


when isMainModule:
  echo "Step 1: ", step1()
  echo "Step 2: ", step2()
