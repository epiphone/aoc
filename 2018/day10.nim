import algorithm
import future
import sequtils
import strformat
import strscans
from times import epochTime


type Point = tuple[x, y, vx, vy: int]

proc read_input(): seq[Point] =
  for line in lines("day10input.txt"):
    var x, y, vx, vy: int
    discard scanf(line, "position=<$s$i,$s$i> velocity=<$s$i,$s$i>", x, y, vx, vy)
    result.add((x, y, vx, vy))

proc step1_and_2(): int =
  var points = read_input()
  var diff: int

  while true:
    var
      min_x = points[0].x
      max_x = points[0].x
      min_y = points[0].y
      max_y = points[0].y

    for i, p in points:
      points[i].x.inc(p.vx)
      points[i].y.inc(p.vy)
      min_x = min(min_x, points[i].x)
      min_y = min(min_y, points[i].y)
      max_x = max(max_x, points[i].x)
      max_y = max(max_y, points[i].y)

    var new_diff = max_x - min_x + max_y - min_y
    if result == 0 or new_diff < diff:
      diff = new_diff
      inc(result)
    else:
      # Go back one second:
      for p in points.mitems:
        p.x.dec(p.vx)
        p.y.dec(p.vy)

      var sorted_points = points
        .sortedByIt((it.y, it.x))
        .reversed()
        .map((d) => (x: d.x, y: d.y)) # In order for deduplication to work
        .deduplicate()
      var next = sorted_points.pop()

      for y in min_y..max_y:
        var line = newStringOfCap(max_x - min_x + 1)
        for x in min_x..max_x:
          if sorted_points.len() > 0 and next.y == y and next.x == x:
            line.add('X')
            next = sorted_points.pop()
          else:
            line.add('.')
        echo line
      break


when isMainModule:
  var time = epochTime()
  echo &"Step 1: {step1_and_2()}, both steps in total took {(epochTime() - time) * 1000:2} ms"
