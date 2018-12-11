import queues
from times import epochTime
import strformat
import strutils

type Cell = tuple[x, y: int]

const INPUT = 18 # 6548

func power_level*(cell: Cell): int =
  let rack_id = cell.x + 10
  result = rack_id * cell.y
  result += INPUT
  result *= rack_id
  result = if result < 100: 0 else: parseInt($($result)[^3])
  return result - 5


proc step1(): Cell =
  var
    queue = initQueue[int]()
    top_cell: Cell
    curr_power: int
    max_power: int

  for y in 1..298:
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
      if x == 33 and y == 45:
        echo "33,45: ", curr_power
      if curr_power > max_power:
        max_power = curr_power
        top_cell = (x, y)

  echo top_cell, ", ", max_power
  return top_cell


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
