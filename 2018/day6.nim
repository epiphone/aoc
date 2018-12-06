import algorithm, sugar
import sequtils
import strformat
from strscans import scanf
import tables
from times import cpuTime

type Coordinate = tuple[x: int, y: int]

proc read_coords*(): seq[Coordinate] =
  for line in lines("day6input.txt"):
    var x, y: int
    discard scanf(line, "$i, $i", x, y)
    result.add((x, y))

func boundaries(coords: openArray[Coordinate]): (int, int, int, int, int, int, int, int) =
  var max_x1, max_x2, max_y1, max_y2: int
  var
    min_x1 = 999
    min_x2 = 999
    min_y1 = 999
    min_y2 = 999

  for coord in coords:
    if coord.x > max_x1:
      max_x2 = max_x1
      max_x1 = coord.x
    elif coord.x > max_x2:
      max_x2 = coord.x
    if coord.x < min_x1:
      min_x2 = min_x1
      min_x1 = coord.x
    elif coord.x < min_x2:
      min_x2 = coord.x

    if coord.y > max_y1:
      max_y2 = max_y1
      max_y1 = coord.y
    elif coord.y > max_y2:
      max_y2 = coord.y
    if coord.y < min_y1:
      min_y2 = min_y1
      min_y1 = coord.y
    elif coord.y < min_y2:
      min_y2 = coord.y

  return (min_x1, min_x2, min_y1, min_y2, max_x1, max_x2, max_y1, max_y2)

func manhattan_distance*(a: Coordinate, b: Coordinate): int =
  return abs(a.x - b.x) + abs(a.y - b.y)


proc step1(): int =
  let coords = read_coords()
  let (min_x1, min_x2, min_y1, min_y2, max_x1, max_x2, max_y1, max_y2) = boundaries(coords)

  echo &"Boundaries x: {max_x1}..{max_x2} - {min_x2}..{min_x1}"
  echo &"Boundaries y: {max_y1}..{max_y2} - {min_y2}..{min_y1}"

  let finite_coords = coords.filter((c) => c.x < max_x2 and min_x2 < c.x and c.y < max_y2 and min_y2 < c.y)
  echo "Finite coords: ", finite_coords

  var areas = newCountTable[Coordinate]()
  for x in min_x1..max_x1:
    for y in min_y1..max_y1:
      var distances: seq[tuple[coord: Coordinate, distance: int]] # TODO: try setting default size to coords.len
      for coord in coords:
        distances.add((coord, manhattan_distance((x, y), coord)))
      distances.sort((a, b) => cmp(a.distance, b.distance))

      let area_coord = distances[0].coord
      if distances[0].distance != distances[1].distance and area_coord in finite_coords:
        if not areas.hasKey(area_coord):
          areas[area_coord] = 1
        else:
          areas[area_coord].inc()

  echo areas

  return areas.largest[1] # 4060


proc step2(): int =
  let coords = read_coords()
  let (min_x, _, min_y, _, max_x, _, max_y, _) = boundaries(coords)

  var region_size = 0
  for x in min_x..max_x:
    for y in min_y..max_y:
      var total_distance = 0
      for coord in coords:
        total_distance.inc(manhattan_distance(coord, (x, y)))
        if total_distance >= 10_000:
          break

      if total_distance < 10_000:
        inc(region_size)

  return region_size


when isMainModule:
  var time = cpuTime()
  echo "Step 1: ", step1(), ", took ", (cpuTime() - time) * 1000, " ms"
  time = cpuTime()
  echo "Step 2: ", step2(), ", took ", (cpuTime() - time) * 1000, " ms"
