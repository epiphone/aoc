import heapqueue, sequtils, sets, strformat, strutils, tables
from times import epochTime
from ./day15 import Point, `+`, `-`

type Point3* = (int, int, int)

func breadth_first_search*[T](p1, p2: T, get_neighbours: proc (p: T): seq[T]): int =
  var
    visited = initHashSet[T]()
    dist = initTable[T, int]()
    q = initHeapQueue[tuple[distance: int, node: T]]()

  q.push((0, p1))

  while q.len() > 0:
    var (origin_dist, origin) = q.pop()
    if origin in visited:
      continue

    if origin == p2:
      return origin_dist

    visited.incl(origin)

    for v in get_neighbours(origin):
      let alt_dist = origin_dist + 1
      let v_dist = dist.getOrDefault(v)
      if v_dist == 0 or alt_dist < v_dist:
        dist[v] = alt_dist
        q.push((alt_dist, v))

  return dist.getOrDefault(p2, -1)


proc step1(): int =
  let lines = toSeq(lines("./input20.txt"))

  var
    neighbours = initTable[Point, HashSet[Point]]()
    labels = initTable[set[char], seq[Point]]()

  for y, line in lines.pairs:
    for x, c in line:
      if c != '.':
        continue

      let dirs = @[(0, -1), (0, 1), (-1, 0), (1, 0)]
      if not ((x, y) in neighbours):
        neighbours[(x, y)] = initHashSet[Point]()

      for dir in dirs:
        let n = (x, y) + dir
        if not (n in neighbours):
          neighbours[n] = initHashSet[Point]()

        if lines[n[1]][n[0]] == '.':
          neighbours[(x, y)].incl(n)
          neighbours[n].incl((x, y))

        if lines[n[1]][n[0]] in 'A'..'Z':
          let
            n2 = (x, y) + dir + dir
            label: set[char] = {lines[n[1]][n[0]], lines[n2[1]][n2[0]]}
          labels.mgetOrPut(label, @[]).add((x, y))

  for label, points in labels:
    if label == {'A'} or label == {'Z'}:
      continue
    neighbours[points[0]].incl(points[1])
    neighbours[points[1]].incl(points[0])

  let
    start_point = labels[{'A'}][0]
    end_point = labels[{'Z'}][0]

  proc get_neighbours(point: Point): seq[Point] = neighbours[point].toSeq()

  return breadth_first_search(start_point, end_point, get_neighbours)


proc step2(): int =
  let lines = toSeq(lines("./input20.txt"))
  var neighbours = initTable[Point, HashSet[Point]]()
  var labels = initTable[set[char], seq[Point]]()

  for y, line in lines.pairs:
    for x, c in line:
      if c != '.':
        continue

      let dirs = @[(0, -1), (0, 1), (-1, 0), (1, 0)]
      if not ((x, y) in neighbours):
        neighbours[(x, y)] = initHashSet[Point]()

      for dir in dirs:
        let n = (x, y) + dir
        if not (n in neighbours):
          neighbours[n] = initHashSet[Point]()

        if lines[n[1]][n[0]] == '.':
          neighbours[(x, y)].incl(n)
          neighbours[n].incl((x, y))

        if lines[n[1]][n[0]] in 'A'..'Z':
          let
            n2 = (x, y) + dir + dir
            label: set[char] = {lines[n[1]][n[0]], lines[n2[1]][n2[0]]}
          labels.mgetOrPut(label, @[]).add((x, y))

  var neighbours3 = initTable[Point3, HashSet[Point3]]()
  proc connect(p1, p2: Point3) =
    neighbours3.mgetOrPut(p1, initHashSet[Point3]()).incl(p2)
    neighbours3.mgetOrPut(p2, initHashSet[Point3]()).incl(p1)

  for z in 0..<labels.len:
    for point, ns in neighbours:
      let point3 = (point[0], point[1], z)
      for n in ns:
        connect(point3, (n[0], n[1], z))

  var portals: seq[(Point, Point)]
  for label, points in labels:
    if label == {'A'} or label == {'Z'}:
      continue
    let
      inner_index = if points[0][0] in {2, lines[2].len - 1} or points[0][1] in {2, lines.len - 3}: 1 else: 0
      outer_index = if inner_index == 0: 1 else: 0
    portals.add((points[inner_index], points[outer_index]))

  for z in 0..<labels.len:
    for (inner, outer) in portals:
      connect((inner[0], inner[1], z), (outer[0], outer[1], z + 1))

  proc get_neighbours(point: Point3): seq[Point3] =
    if point in neighbours3: neighbours3[point].toSeq() else: @[]

  let
    start_point = (labels[{'A'}][0][0], labels[{'A'}][0][1], 0)
    end_point = (labels[{'Z'}][0][0], labels[{'Z'}][0][1], 0)

  return breadth_first_search(start_point, end_point, get_neighbours)


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
