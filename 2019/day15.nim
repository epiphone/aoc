from ./day13 import init_computer, process
import osproc, sequtils, sets, strutils, tables

type Point* = (int, int)

func `+`*(a, b: Point): Point = (a[0] + b[0], a[1] + b[1])
func `-`*(a, b: Point): Point = (a[0] - b[0], a[1] - b[1])

let
  input = "3,1033,1008,1033,1,1032,1005,1032,31,1008,1033,2,1032,1005,1032,58,1008,1033,3,1032,1005,1032,81,1008,1033,4,1032,1005,1032,104,99,102,1,1034,1039,1002,1036,1,1041,1001,1035,-1,1040,1008,1038,0,1043,102,-1,1043,1032,1,1037,1032,1042,1105,1,124,102,1,1034,1039,1002,1036,1,1041,1001,1035,1,1040,1008,1038,0,1043,1,1037,1038,1042,1106,0,124,1001,1034,-1,1039,1008,1036,0,1041,1002,1035,1,1040,101,0,1038,1043,1002,1037,1,1042,1105,1,124,1001,1034,1,1039,1008,1036,0,1041,1001,1035,0,1040,1001,1038,0,1043,1001,1037,0,1042,1006,1039,217,1006,1040,217,1008,1039,40,1032,1005,1032,217,1008,1040,40,1032,1005,1032,217,1008,1039,1,1032,1006,1032,165,1008,1040,5,1032,1006,1032,165,1101,2,0,1044,1106,0,224,2,1041,1043,1032,1006,1032,179,1102,1,1,1044,1106,0,224,1,1041,1043,1032,1006,1032,217,1,1042,1043,1032,1001,1032,-1,1032,1002,1032,39,1032,1,1032,1039,1032,101,-1,1032,1032,101,252,1032,211,1007,0,72,1044,1105,1,224,1101,0,0,1044,1105,1,224,1006,1044,247,1001,1039,0,1034,101,0,1040,1035,1001,1041,0,1036,1001,1043,0,1038,1001,1042,0,1037,4,1044,1106,0,0,50,46,95,30,15,91,60,70,74,3,22,60,94,68,47,99,65,61,23,17,82,21,80,87,27,62,53,46,89,98,55,64,15,41,82,13,45,78,18,28,87,17,24,22,81,92,30,70,97,22,85,71,32,73,35,93,78,54,85,45,46,75,51,97,73,85,37,87,29,92,85,75,10,21,79,60,85,31,79,73,7,81,4,77,45,17,82,78,37,85,95,83,17,56,52,85,79,78,32,91,79,37,75,51,46,20,21,16,93,87,22,42,74,87,22,84,20,69,35,97,88,76,78,85,26,64,84,80,38,92,58,87,84,98,38,20,75,78,69,80,47,54,78,95,85,90,24,44,84,74,11,1,92,80,58,12,4,97,31,49,73,9,85,55,84,49,93,82,22,47,75,44,55,83,71,21,52,94,24,79,36,88,5,43,61,40,87,83,28,28,84,83,11,43,90,99,41,87,29,76,48,93,91,58,50,29,90,13,23,6,73,97,45,98,83,93,40,85,79,66,89,5,94,50,81,65,42,81,91,97,53,99,50,88,28,54,33,79,36,31,95,70,89,87,57,94,80,97,82,68,79,38,94,2,88,8,88,45,1,98,28,91,64,85,97,34,95,47,90,70,86,13,38,68,93,74,57,73,89,31,81,34,48,80,92,39,7,83,2,77,54,77,68,86,20,64,86,32,81,6,73,37,59,82,47,86,19,86,45,92,82,56,57,94,54,9,9,76,14,9,85,81,84,42,86,60,68,89,15,75,42,49,93,2,97,83,83,64,87,85,71,73,3,36,94,5,8,25,82,11,86,36,37,93,79,31,92,84,25,90,9,83,68,71,81,28,84,17,88,71,69,87,7,87,56,98,5,66,94,80,83,43,95,92,7,73,90,23,7,11,60,3,89,92,30,95,98,1,94,27,95,68,15,86,42,92,48,8,77,91,52,76,68,41,88,94,83,25,28,75,36,87,56,39,77,68,77,96,44,85,97,14,41,73,97,52,62,99,34,54,78,87,24,92,84,95,64,45,76,11,83,98,32,98,25,76,33,79,11,93,94,46,93,27,46,75,92,43,30,11,52,96,15,8,98,94,47,73,80,54,84,18,92,64,39,92,93,95,77,64,94,28,88,49,73,43,39,82,58,41,87,91,22,32,48,87,39,61,85,74,91,17,92,90,52,78,53,49,28,22,79,51,75,53,89,28,3,81,22,64,19,51,77,34,78,88,36,83,91,40,11,74,75,19,91,27,12,34,93,24,82,90,43,42,94,66,86,85,62,93,12,78,81,57,75,81,63,54,99,97,83,6,94,90,50,66,94,39,83,35,78,76,57,79,45,27,88,53,55,18,97,4,49,89,42,51,74,46,93,87,24,97,58,35,85,89,30,90,4,89,46,91,67,99,91,91,70,24,97,30,48,77,82,46,94,63,90,89,45,82,32,88,25,37,75,85,73,68,9,94,39,68,83,54,22,87,84,42,98,41,87,65,80,54,23,54,17,83,98,17,90,1,96,55,85,63,66,95,78,84,77,73,60,27,94,21,79,90,62,90,85,11,87,83,26,88,61,75,60,47,80,6,36,84,79,99,61,79,12,38,76,17,45,88,83,15,74,66,38,88,23,44,87,77,33,78,56,23,45,52,83,89,71,52,74,17,75,52,80,95,83,28,69,87,57,52,94,80,9,90,63,91,45,85,31,90,47,78,40,74,80,75,11,95,18,97,84,73,63,87,45,74,30,81,16,95,31,93,68,81,9,79,74,94,33,83,66,76,52,80,0,0,21,21,1,10,1,0,0,0,0,0,0"
  move_to_command_mapping = toTable(@[((-1, 0), 4), ((0, -1), 1), ((0, 1), 2), ((1, 0), 3)])

proc render_points*(points: Table[Point, char]) =
  discard execCmd "clear"
  var min_x, max_x, min_y, max_y: int
  for point in points.keys:
    min_x = min(min_x, point[0])
    max_x = max(max_x, point[0])
    min_y = min(min_y, point[1])
    max_y = max(max_y, point[1])

  for y in min_y..max_y:
    echo toSeq(min_x..max_x).mapIt(points.getOrDefault((it, y), ' ')).join()


proc shortest_path*(p1, p2: Point, points: seq[Point], get_neighbours: proc (p: Point): seq[Point]): int =
  ## Dijkstra's algorithm
  var
    unvisited = initHashSet[Point]()
    dist = initTable[Point, int]()
    prev = initTable[Point, Point]()

  for vertex in points:
    dist[vertex] = 9999
    unvisited.incl(vertex)

  dist[p1] = 0

  while unvisited.len > 0:
    var vertex = toSeq(unvisited.items)[0]
    for u in unvisited:
      if dist[u] < dist[vertex]:
        vertex = u

    if vertex == p2:
      break

    unvisited.excl(vertex)

    for neighbour in get_neighbours(vertex):
      let alt = dist[vertex] + 1
      if alt < dist[neighbour]:
        dist[neighbour] = alt
        prev[neighbour] = vertex

  return dist[p2]


proc step1(): int =
  var
    computer = init_computer(input, @[])
    position = (0, 0)
    points = toTable(@[(position, 'D')])
    path: seq[Point] = @[(0, 0)]

  proc next_available_move(): Point =
    for move in move_to_command_mapping.keys:
      let new_pos = position + move
      if not (new_pos in points) and new_pos != path[^1]:
        return move
    return (0, 0)

  while true:
    var
      backtracking = false
      move = next_available_move()
    if move == (0, 0):
      backtracking = true
      move = path.pop() - position

    let command = move_to_command_mapping[move]
    computer.inputs = @[command]
    let output = process(computer)[0]

    case output
    of 0:
      points[position + move] = '#'
    of 1:
      points[position] = '.'
      if not backtracking:
        path.add(position)
      position = position + move
      points[position] = 'D'
    else:
      points[position] = '.'
      position = position + move
      points[position] = '!'
      break

  proc get_neighbours(point: Point): seq[Point] =
    for move in move_to_command_mapping.keys:
      if points.getOrDefault(point + move, '#') != '#':
        result.add(point + move)

  return shortest_path((0, 0), position, toSeq(points.keys), get_neighbours)


proc step2(): int =
  var
    computer = init_computer(input, @[])
    position = (0, 0)
    points = toTable(@[(position, '.')])
    path: seq[Point] = @[position]

  proc next_available_move(): Point =
    for move in move_to_command_mapping.keys:
      let new_pos = position + move
      if not (new_pos in points) and new_pos != path[^1]:
        return move
    return (0, 0)

  # 1. Discover the whole map:
  while true:
    var
      backtracking = false
      move = next_available_move()

    if move == (0, 0):
      backtracking = true
      move = path.pop() - position
      if path.len == 0:
        break # the whole map discovered

    let command = move_to_command_mapping[move]
    computer.inputs = @[command]
    let output = process(computer)[0]

    case output
    of 0:
      points[position + move] = '#'
    of 1, 2:
      if not backtracking:
        path.add(position)
      position = position + move
      points[position] = '.'
    else:
      raise newException(Exception, "invalid output: " & $output)

  # 2. Fill with oxygen:
  var spreading_from = @[(20, -16)]

  proc unfilled_neighbours(point: Point): seq[Point] =
    for move in move_to_command_mapping.keys:
      if points.getOrDefault(point + move, '#') == '.':
        result.add(point + move)

  while true:
    var new_spreading_from: seq[Point]

    for point in spreading_from:
      for neighbour in unfilled_neighbours(point):
        new_spreading_from.add(neighbour)
        points[neighbour] = '0'

    if new_spreading_from.len == 0:
      break

    spreading_from = new_spreading_from
    result += 1


when isMainModule:
  echo "Step 1: ", step1()
  echo "Step 2: ", step2()
