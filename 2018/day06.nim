## This one's a mess!

import algorithm, sugar
import sequtils
import sets
import strformat
from strscans import scanf
import tables
from times import cpuTime

type Coordinate = tuple[x: int, y: int]

proc read_coords*(): seq[Coordinate] =
  for line in lines("inputs/day06.txt"):
    var x, y: int
    discard scanf(line, "$i, $i", x, y)
    result.add((x, y))

func boundaries(coords: openArray[Coordinate]): (int, int, int, int, int, int, int, int) =
  ## Return the top 2 max/min values in X and Y coordinates
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


func convex_hull*(coords: openArray[Coordinate]): seq[Coordinate] =
    ## Compute the convex hull of a set of 2D points using Andrew's monotone chain algorithm:
    ## https://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain
    let sorted_coords = coords.sorted(cmp)

    func cross(o: Coordinate, a: Coordinate, b: Coordinate): int =
      ## 2D cross product of OA and OB vectors, i.e. z-component of their 3D cross product.
      ## Returns a positive value, if OAB makes a counter-clockwise turn,
      ## negative for clockwise turn, and zero if the points are collinear.
      return (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x)

    # Build lower hull
    var lower: seq[Coordinate]
    for c in sorted_coords:
      while len(lower) >= 2 and cross(lower[^2], lower[^1], c) <= 0:
        discard lower.pop()
      lower.add(c)

    # Build upper hull
    var upper: seq[Coordinate]
    for c in reversed(sorted_coords):
      while len(upper) >= 2 and cross(upper[^2], upper[^1], c) <= 0:
        discard upper.pop()
      upper.add(c)

    # Concatenation of the lower and upper hulls gives the convex hull.
    # Last point of each list is omitted because it is repeated at the beginning of the other list.
    return lower[0..^2] & upper[0..^2]


func orthogonal_convex_hull*(coords: openArray[Coordinate]): seq[Coordinate] =
  ## Compute the orthogonal convex hull of a set of 2D points:
  ## https://en.wikipedia.org/wiki/Orthogonal_convex_hull
  let
    sorted_coords = coords.sorted(cmp)
    rev_sorted_coords = reversed(sorted_coords)
  var
    upper_hull = @[sorted_coords[0]]
    lower_hull = @[sorted_coords[^1]]
  var top_left, top_right, btm_left, btm_right: seq[Coordinate]

  for c in sorted_coords:
    if top_left.len == 0:
      top_left.add(c)
    else:
      let prev = top_left[^1]
      if c.y > prev.y:
        top_left.add(c)

  for c in rev_sorted_coords:
    if top_right.len == 0:
      top_right.add(c)
    else:
      let prev = top_right[^1]
      if c.y > prev.y:
        top_right.add(c)

  for c in sorted_coords:
    if btm_left.len == 0:
      btm_left.add(c)
    else:
      let prev = btm_left[^1]
      if c.y < prev.y:
        btm_left.add(c)

  for c in rev_sorted_coords:
    if btm_right.len == 0:
      btm_right.add(c)
    else:
      let prev = btm_right[^1]
      if c.y < prev.y:
        btm_right.add(c)

  return toSeq(toSet(top_left & top_right & btm_right & btm_left).items)

  # for c in sorted_coords[1..^1]:
  #   let prev = upper_hull[^1]
  #   if c != prev and c.x >= prev.x and c.y >= prev.y:
  #     upper_hull.add(c)
  # for c in rev_sorted_coords:
  #   let prev = upper_hull[^1]
  #   if c != prev and c.x <= prev.x and c.y >= prev.y:
  #     upper_hull.add(c)

  # for c in sorted_coords[1..^1]:
  #   let prev = lower_hull[^1]
  #   if c != prev and c.x >= prev.x and c.y <= prev.y:
  #     lower_hull.add(c)
  # for c in reversed(sorted_coords)[1..^1]:
  #   let prev = lower_hull[^1]
  #   if c != prev and c.x <= prev.x and c.y <= prev.y:
  #     lower_hull.add(c)

  # return upper_hull & lower_hull


proc step1(): int =
  let coords = read_coords()
  let (min_x1, min_x2, min_y1, min_y2, max_x1, max_x2, max_y1, max_y2) = boundaries(coords)

  echo &"Boundaries x: {max_x1}..{max_x2} - {min_x2}..{min_x1}"
  echo &"Boundaries y: {max_y1}..{max_y2} - {min_y2}..{min_y1}"

  # Coordinate is finite when its x value is between the 2nd smallest and the
  # 2nd largest X coordinate value, and vice versa for the Y value:
  var finite_coords = initSet[Coordinate]()
  for c in coords:
    if c.x < max_x2 and min_x2 < c.x and c.y < max_y2 and min_y2 < c.y:
      finite_coords.incl(c)

  let max_distance = 68 # Found by manual experimentation
  var areas = newCountTable[Coordinate]()

  for x in min_x2..max_x2:
    for y in min_y2..max_y2:
      var distances: seq[tuple[coord: Coordinate, distance: int]]
      for i, coord in coords:
        # We can safely skip coordinates that are sufficiently far away in either X or Y dimension:
        if abs(x - coord.x) > max_distance or abs(y - coord.y) > max_distance:
          continue
        let distance = manhattan_distance((x, y), coord)
        distances.add((coord, distance))
      distances.sort((a, b) => cmp(a.distance, b.distance))

      let closest_coord = distances[0].coord
      if distances[0].distance != distances[1].distance and closest_coord in finite_coords:
        if not areas.hasKey(closest_coord):
          areas[closest_coord] = 1
        else:
          areas[closest_coord].inc()

  sort(areas)
  for k, v in areas:
    echo &"{k.x:3},{k.y:3}: {v}"

  return areas.largest[1] # 4060


proc step1_convex_hull(): int =
  let coords = read_coords()
  let convex_hull = orthogonal_convex_hull(coords)
  let (min_x1, min_x2, min_y1, min_y2, max_x1, max_x2, max_y1, max_y2) = boundaries(convex_hull)

  echo &"Boundaries x: {max_x1}..{max_x2} - {min_x2}..{min_x1}"
  echo &"Boundaries y: {max_y1}..{max_y2} - {min_y2}..{min_y1}"

  var areas = newCountTable[Coordinate]()
  echo "Convex hull: ", convex_hull
  for c in convex_hull:
    echo &"{c.x},{c.y}"
  echo "SOLUTION IN CONVEX HULL: ", (283, 113) in convex_hull

  for x in min_x1..max_x1:
    for y in min_y1..max_y1:
      var distances: seq[tuple[coord: Coordinate, distance: int]]
      for coord in coords:
        let distance = manhattan_distance((x, y), coord)
        distances.add((coord, distance))
      distances.sort((a, b) => cmp(a.distance, b.distance))

      let closest_coord = distances[0].coord
      if distances[0].distance != distances[1].distance and not (closest_coord in convex_hull):
        if not areas.hasKey(closest_coord):
          areas[closest_coord] = 1
        else:
          areas[closest_coord].inc()

  sort(areas)
  for k, v in areas:
    echo &"{k.x:3},{k.y:3}: {v}"

  return areas.largest[1] # 4060


proc step1_alternative(): int =
  let coords = read_coors()
  let (min_x, _, min_y, _, max_x, _, max_y, _) = boundaries(coords)
  var border: seq[Coordinate]
  for c in coords:
    if c.x == min_x or c.x == max_x or c.y == min_y or c.y == max_y:
      border.add(c)
    else:
      let
        top_offset = max_y - c.y

      if top_offset >= c.x - min_x or



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
  # echo "Step 1: ", step1(), ", took ", (cpuTime() - time) * 1000, " ms"
  # time = cpuTime()
  # echo "Step 1 with convex hull: ", step1_convex_hull(), ", took ", (cpuTime() - time) * 1000, " ms"
  time = cpuTime()
  echo "Step 1 alternative: ", step1_alternative(), ", took ", (cpuTime() - time) * 1000, " ms"
  # time = cpuTime()
  # echo "Step 2: ", step2(), ", took ", (cpuTime() - time) * 1000, " ms"
