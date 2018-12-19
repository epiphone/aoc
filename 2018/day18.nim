import math, sequtils, strformat
from times import epochTime


type
  Grid = array[100, array[100, char]]

proc read_input(): Grid =
  var y = 0
  for line in lines("inputs/day18.txt"):
    for x, c in line:
      result[y][x] = c
    y.inc()

proc step1(): int =
  var old_grid, grid = read_input()

  proc step_grid() =
    for y, row in old_grid:
      for x, c in row:
        if c == '.':
          block check_block:
            var trees = 0
            for offset_y in max(y - 1, 0)..min(y + 1, 49):
              for offset_x in max(x - 1, 0)..min(x + 1, 49):
                if old_grid[offset_y][offset_x] == '|':
                  trees.inc()
                  if trees >= 3:
                    grid[y][x] = '|'
                    break check_block
            grid[y][x] = '.'
        elif c == '|':
          block check_block2:
            var trees = 0
            for offset_y in max(y - 1, 0)..min(y + 1, 49):
              for offset_x in max(x - 1, 0)..min(x + 1, 49):
                if old_grid[offset_y][offset_x] == '#':
                  trees.inc()
                  if trees >= 3:
                    grid[y][x] = '#'
                    break check_block2
            grid[y][x] = '|'
        elif c == '#':
          block check_block3:
            var lumberyards, trees = 0
            for offset_y in max(y - 1, 0)..min(y + 1, 49):
              for offset_x in max(x - 1, 0)..min(x + 1, 49):
                if (offset_y != y or offset_x != x) and old_grid[offset_y][offset_x] == '#':
                  lumberyards.inc()
                  if lumberyards >= 1 and trees >= 1:
                    grid[y][x] = '#'
                    break check_block3
                elif old_grid[offset_y][offset_x] == '|':
                  trees.inc()
                  if lumberyards >= 1 and trees >= 1:
                    grid[y][x] = '#'
                    break check_block3
            grid[y][x] = '.'
    old_grid = grid

  # Step 2: run long enough for a stable pattern to emerge...
  for i in 1..1200:
    step_grid()
  # ...then skip the unnecessary cycles and finish with the remainder:
  for j in 1..floorMod(1_000_000_000 - 1200, 28):
    step_grid()

  var woods, lumberyards = 0
  for row in grid:
    for c in row:
      if c == '|':
        woods.inc()
      elif c == '#':
        lumberyards.inc()
  return woods * lumberyards

when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
