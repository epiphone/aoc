import algorithm, heapqueue, queues, sequtils, strformat, sets, sugar, tables
from times import epochTime


type
  Point = tuple[x, y: int]
  Region = enum rocky, wet, narrow
  Tool = enum climbing_gear, torch, neither
  Move = tuple[moved_to: Point, tool_after: Tool, cost: int]

const DEPTH = 8112
const TARGET: Point = (13, 743)

const REGION_TYPES = [rocky, wet, narrow]
const OFFSETS: array[4, Point] = [(0, 1), (1, 0), (0, -1), (-1, 0)]
const ALLOWED_TOOLS = [{climbing_gear, torch}, {climbing_gear, neither}, {torch, neither}]


proc geologic_index(p: Point): int

proc erosion_level(p: Point): int =
  return (geologic_index(p) + DEPTH) mod 20183


var geologic_indexes = initTable[Point, int]()
proc geologic_index(p: Point): int =
  if p in geologic_indexes:
    return geologic_indexes[p]

  if p == (0, 0) or p == TARGET:
    result = 0
  elif p.y == 0:
    result = p.x * 16807
  elif p.x == 0:
    result = p.y * 48271
  else:
    result = erosion_level((p.x - 1, p.y)) * erosion_level((p.x, p.y - 1))

  geologic_indexes[p] = result


proc region_type(p: Point): Region =
  return REGION_TYPES[erosion_level(p) mod 3]


proc step1(): int =
  for y in 0..TARGET.y:
    for x in 0..TARGET.x:
      result += int(region_type((x, y)))


proc possible_moves(origin: Point, equipped_tool: Tool): seq[Move] =
  let origin_region = region_type(origin)
  for x, y in OFFSETS.items:
    let target: Point = (origin.x + x, origin.y + y)
    if target.x < 0 or target.y < 0:
      continue
    if target.x > TARGET.x + 50 or target.y > TARGET.y + 100:
      continue
    let target_region = region_type(target)
    let possible_tools = ALLOWED_TOOLS[int(origin_region)] * ALLOWED_TOOLS[int(target_region)]
    for tool in possible_tools:
      result.add((target, tool, if tool == equipped_tool: 1 else: 8))


proc step2(): int =
  # Dijkstra's algorithm:
  type Node = tuple[pos: Point, tool: Tool]
  var
    dist = {(pos: (0, 0), tool: torch): 0}.toTable()
    visited = initSet[Node]()
    q = newHeapQueue[tuple[distance: int, node: Node]]()
  q.push((0, (pos: (0, 0), tool: torch)))

  while len(q) > 0:
    var (origin_dist, origin) = q.pop()
    if origin in visited:
      continue

    if origin == (TARGET, torch):
      return origin_dist

    visited.incl(origin)

    for move in possible_moves(origin.pos, origin.tool):
      let alt_dist = origin_dist + move.cost
      let v: Node = (pos: move.moved_to, tool: move.tool_after)
      let v_dist = dist.getOrDefault(v)
      if v_dist == 0 or alt_dist < v_dist:
        dist[v] = alt_dist
        q.push((alt_dist, v))

  return dist[(pos: TARGET, tool: torch)]


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
