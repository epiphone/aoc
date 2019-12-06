from sequtils import toSeq
from strutils import split
import sets, tables

proc read_input(): seq[string] =
  for line in lines("./input06.txt"):
    result.add(line)

proc step1(): int =
  var orbits = initTable[string, string]()
  for row in read_input():
    let parts = row.split(')')
    assert parts.len == 2
    orbits[parts[1]] = parts[0]

  for val in orbits.values:
    var origin = val
    result += 1
    while true:
      if orbits.contains(origin):
        result += 1
        origin = orbits[origin]
      else:
        break


proc step2(): int =
  var neighbours = initTable[string, HashSet[string]]()

  for row in read_input():
    let parts = row.split(')')
    assert parts.len == 2

    if not (parts[0] in neighbours):
      neighbours[parts[0]] = initHashSet[string]()
    if not (parts[1] in neighbours):
      neighbours[parts[1]] = initHashSet[string]()

    neighbours[parts[0]].incl(parts[1])
    neighbours[parts[1]].incl(parts[0])

  # Dijkstra's algorithm:
  var
    unvisited = initHashSet[string]()
    dist = initTable[string, int]()
    prev = initTable[string, string]()

  for vertex in neighbours.keys:
    dist[vertex] = 9999
    unvisited.incl(vertex)

  dist["YOU"] = 0

  while unvisited.len > 0:
    var vertex = toSeq(unvisited.items)[0]
    for u in unvisited:
      if dist[u] < dist[vertex]:
        vertex = u

    if vertex == "SAN":
      break

    unvisited.excl(vertex)

    for neighbour in neighbours[vertex]:
      let alt = dist[vertex] + 1
      if alt < dist[neighbour]:
        dist[neighbour] = alt
        prev[neighbour] = vertex

  return dist["SAN"] - 2


when isMainModule:
  echo "Step 1: ", step1()
  echo "Step 2: ", step2()
