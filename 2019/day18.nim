import heapqueue, sequtils, strformat, strutils, tables, times
from ./day15 import Point, `+`
from ./day20 import breadth_first_search


proc read_input(): seq[string] =
  for line in lines("./input18.txt"):
    result.add(line)

func toSet*[T](a: openarray[T]): set[T] =
  for item in a: result.incl(item)

func dijkstra*[T](p1, p2: T, get_neighbours: proc (p: T): set[T], get_weight: proc (p1, p2: T): int): int =
  var
    visited: set[T] = {}
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
      let
        alt_dist = origin_dist + get_weight(origin, v)
        v_dist = dist.getOrDefault(v)

      if v_dist == 0 or alt_dist < v_dist:
        dist[v] = alt_dist
        q.push((alt_dist, v))

  return dist.getOrDefault(p2, -1)


proc step1(): int =
  let input = read_input()
  var map_items = initTable[char, Point]()

  for y, line in input.pairs:
    for x, c in line.pairs:
      if not (c.toLowerAscii() in {'#', '.'}):
        map_items[c] = (x, y)

  # Pre-populate distances between map items:
  let map_keys = toSeq(map_items.keys)
  var distances = initTable[char, Table[char, int]]()
  for i, k1 in map_keys.pairs:
    for k2 in map_keys[(i + 1)..^1]:
      if k2 == '@':
        continue

      proc get_neighbours(p: Point): seq[Point] =
        for dir in @[(0, -1), (0, 1), (-1, 0), (1, 0)]:
          let tile = input[p[1] + dir[1]][p[0] + dir[0]]
          if tile != '#':
            result.add(p + dir)

      let dist = breadth_first_search(map_items[k1], map_items[k2], get_neighbours)
      if dist > -1:
        distances.mgetOrPut(k1, initTable[char, int]())[k2] = dist
        if k1 != '@':
          distances.mgetOrPut(k2, initTable[char, int]())[k1] = dist


  var shortest_dist_between_keys_memo_table = initTable[(char, char, set[char]), int]()

  proc shortest_dist_between_keys(a, b: char, keys_left: set[char]): int =
    let cache_key = (a, b, keys_left)
    if cache_key in shortest_dist_between_keys_memo_table:
      return shortest_dist_between_keys_memo_table[cache_key]

    proc get_neighbours(key: char): set[char] =
      for neighbour in distances[key].keys:
        if neighbour.isUpperAscii() and neighbour.toLowerAscii() in keys_left:
          continue
        result.incl(neighbour)

    proc get_weight(k1, k2: char): int =
      distances[k1][k2]

    result = dijkstra(a, b, get_neighbours, get_weight)
    shortest_dist_between_keys_memo_table[cache_key] = result

  var
    curr_min = 5000
    shortest_path_memo_table = initTable[(char, set[char], int), int]()

  proc shortest_path(origin: char, keys_left: set[char], curr_len = 0): int =
    let cache_key = (origin, keys_left, curr_len)
    if cache_key in shortest_path_memo_table:
      return shortest_path_memo_table[cache_key]

    if curr_len >= curr_min:
      return 0

    if keys_left.len == 0:
      echo &"new min: {curr_len}"
      curr_min = curr_len
      return curr_len

    for key in keys_left:
      let path_len = shortest_dist_between_keys(origin, key, keys_left)
      if path_len == -1:
        continue

      let res = shortest_path(key, keys_left - {key}, curr_len + path_len)
      if res > 0 and res < result:
        result = res

    shortest_path_memo_table[cache_key] = result

  let all_keys = toSeq(map_items.keys).filterIt(it in 'a'..'z').toSet()
  return shortest_path('@', all_keys)


proc step2(): int =
  discard


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
