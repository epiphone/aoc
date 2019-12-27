import math, sequtils, sets, strformat, tables, times

type Tiles = array[5 * 5, bool]

let raw_input = """..#.#
#.##.
.#..#
#....
....#"""

proc read_input(): Tiles =
  var i = 0
  for c in raw_input:
    if c == '\n':
      continue
    if c == '#':
      result[i] = true
    elif c == '.':
      result[i] = false
    i += 1


const dirs = @[(0, 1), (0, -1), (1, 0), (-1, 0)]

func neighbours_count(tiles: Tiles, x, y: int): int =
  for dir in dirs:
    let n = (y + dir[1]) * 5 + x + dir[0]
    if (dir[1] == 0 and (n < y * 5 or n >= (y + 1) * 5)) or n < 0 or n >= 25:
      continue

    if tiles[n]:
      result += 1

func step(tiles: Tiles): Tiles =
  for y in 0..4:
    for x in 0..4:
      let
        tile = tiles[y * 5 + x]
        ns = neighbours_count(tiles, x, y)
      result[y * 5 + x] = (tile and ns == 1) or (not tile and ns in {1, 2})

func biodiversity_rating(tiles: Tiles): int =
  for i, tile in tiles.pairs:
    if tile:
      result += 2^i

proc step1(): int =
  var
    state = read_input()
    prev_states = toHashSet(@[state])

  while true:
    state = step(state)
    if state in prev_states:
      return biodiversity_rating(state)
    prev_states.incl(state)


type Levels = Table[int, Tiles]

const empty_tiles: Tiles = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]

func neighbours_count(levels: Levels, level, x, y: int): int =
  let tiles = levels[level]

  for dir in dirs:
    let n = (y + dir[1]) * 5 + x + dir[0]

    if n == 12:
      let child_tiles = levels.getOrDefault(level + 1, empty_tiles)

      if dir == (0, 1):
        result += child_tiles[0..4].filterIt(it).len
      elif dir == (0, -1):
        result += child_tiles[^5..^1].filterIt(it).len
      elif dir == (1, 0):
        result += toSeq(0..4).mapIt(child_tiles[it * 5]).filterIt(it).len
      elif dir == (-1, 0):
        result += toSeq(0..4).mapIt(child_tiles[(it + 1) * 5 - 1]).filterIt(it).len

    elif (dir[1] == 0 and (n < y * 5 or n >= (y + 1) * 5)) or n < 0 or n >= 25:
      let parent_tiles = levels.getOrDefault(level - 1, empty_tiles)
      if dir == (0, 1):
        result += parent_tiles[3 * 5 + 2].int
      elif dir == (0, -1):
        result += parent_tiles[1 * 5 + 2].int
      elif dir == (1, 0):
        result += parent_tiles[2 * 5 + 3].int
      elif dir == (-1, 0):
        result += parent_tiles[2 * 5 + 1].int

    elif tiles[n]:
      result += 1

func step(levels: Levels): Levels =
  for level, tiles in levels:
    var new_tiles: Tiles

    for y in 0..4:
      for x in 0..4:
        # Skip the recursive center tile:
        if (x, y) == (2, 2):
          continue

        let
          tile = tiles[y * 5 + x]
          ns = neighbours_count(levels, level, x, y)
        new_tiles[y * 5 + x] = (tile and ns == 1) or (not tile and ns in {1, 2})

    result[level] = new_tiles


func bugs_count(levels: Levels): int =
  for tiles in levels.values:
    for i, tile in tiles:
      if tile and i != 12:
        result += 1


proc step2(): int =
  var
    levels: Levels = initTable[int, Tiles]()
    min_level = 0
    max_level = 0
    minutes_passed = 0

  levels[0] = read_input()

  while minutes_passed < 200:
    if levels[min_level] != empty_tiles:
      min_level -= 1
      levels[min_level] = empty_tiles
    if levels[max_level] != empty_tiles:
      max_level += 1
      levels[max_level] = empty_tiles

    levels = step(levels)
    minutes_passed += 1

  return bugs_count(levels)


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
