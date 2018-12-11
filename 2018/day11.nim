import queues
from times import epochTime
import strformat
import strutils
import tables

type Cell = tuple[x, y: int]

const INPUT = 6548

var memo_table = initTable[Cell, int]()
proc power_level*(cell: Cell): int =
  if cell in memo_table:
    return memo_table[cell]
  let rack_id = cell.x + 10
  result = rack_id * cell.y
  result += INPUT
  result *= rack_id
  result = if result < 100: 0 else: parseInt($($result)[^3])
  result -= 5
  memo_table[cell] = result


proc step1(): Cell =
  var
    queue = initQueue[int]()
    top_cell: Cell
    curr_power: int
    max_power: int

  for y in 1..298:
    while queue.len() > 0:
      discard queue.dequeue()

    curr_power = 0
    for i in 1..3:
      for j in 0..<3:
        let cell_power = power_level((i, y + j))
        queue.enqueue(cell_power)
        curr_power.inc(cell_power)
    if curr_power > max_power:
      max_power = curr_power
      top_cell = (1, y)

    for x in 4..298:
      for i in countup(0, 2):
        curr_power.dec(queue.dequeue())
      for j in countup(0, 2):
        let cell_power = power_level((x, y + j))
        curr_power.inc(cell_power)
        queue.enqueue(cell_power)
      if curr_power > max_power:
        max_power = curr_power
        top_cell = (x - 2, y)

  return top_cell


proc step2(): (Cell, int) =
  var max_power = 0

  for y in 1..300:
    echo "y ", y
    for x in 1..300:
      var max_r = min(301 - x, 301 - y)
      var square_power = power_level((x, y))
      for r in 0..<max_r:
        for i in 0..<r:
          square_power += power_level((x + i, y + r))
          square_power += power_level((x + r, y + i))
        if square_power > max_power:
          max_power = square_power
          result = ((x, y), r + 1)


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
