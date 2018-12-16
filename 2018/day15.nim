import algorithm, queues, sequtils, sets, strformat, sugar, tables
from times import epochTime


const OFFSETS = [(0, -1), (-1, 0), (1, 0), (0, 1)]
var ELF_ATTACK_POWER = 3

type
  Point = tuple[x, y: int]
  Team = enum elf, goblin
  Terrain = enum open, wall
  Unit = tuple[pos: Point, hp: int, team: Team]


proc read_input(): (seq[seq[Terrain]], seq[Unit]) =
  var y = 0
  for line in lines("inputs/day15.txt"):
    var row: seq[Terrain] = @[]
    for x, c in line:
      if c == '#':
        row.add(wall)
      else:
        row.add(open)
        if c != '.':
          result[1].add((pos: (x, y), hp: 200, team: if c == 'G': goblin else: elf))
    result[0].add(row)
    y += 1

func adjacent_squares(pos: Point): OrderedSet[Point] =
  result = initOrderedSet[Point]()
  for offset in OFFSETS:
    result.incl((pos.x + offset[0], pos.y + offset[1]))

proc step1(): int =
  var (grid, units) = read_input()

  proc print_state() =
    for y, row in grid:
      var row_str = newStringOfCap(len(grid[0]))
      for x, item in row:
        block row_item_block:
          for u in units:
            if u.hp > 0 and u.pos.x == x and u.pos.y == y:
              row_str.add(if u.team == goblin: 'G' else: 'E')
              break row_item_block
          row_str.add(if item == open: '.' else: '#')
      echo row_str

  func nth_unit_in_pos(pos: Point): int8 =
    for i, u in units:
      if u.pos == pos and u.hp > 0:
        return int8(i)
    return -1

  func is_open(pos: Point): bool =
    grid[pos.y][pos.x] == open

  func breadth_first_search(source: Point): Table[Point, Point] =
    result = initTable[Point, Point]()
    var unvisited = initQueue[Point]()
    var visited = initSet[Point]()
    unvisited.enqueue(source)

    while len(unvisited) > 0:
      let sub_root = unvisited.dequeue()
      # TODO stop here if all targets are found
      for neighbour in adjacent_squares(sub_root):
        if not is_open(neighbour) or nth_unit_in_pos(neighbour) > -1 or neighbour in visited:
          continue
        if not (neighbour in unvisited):
          result[neighbour] = sub_root
          unvisited.enqueue(neighbour)
      visited.incl(sub_root)

  func reachable_enemy_i(attacker: Unit): int =
    var in_range: seq[int]
    for offset in OFFSETS:
      let enemy_in_pos = nth_unit_in_pos((attacker.pos.x + offset[0], attacker.pos.y + offset[1]))
      if enemy_in_pos > -1 and units[enemy_in_pos].team != attacker.team:
        in_range.add(enemy_in_pos)
    if in_range.len() > 0:
      return in_range.sortedByIt((units[it].hp, units[it].pos.y, units[it].pos.x))[0]
    else:
      return -1

  var round = 0
  while true:
    units = sortedByIt(units, (it.pos.y, it.pos.x))
    round += 1

    for i, u in units.mpairs:
      if u.hp <= 0:
        continue
      var squares_in_range = initSet[Point]()
      for pos, hp, team in units.items:
        if hp > 0 and team != u.team:
          for p in adjacent_squares(pos):
            if is_open(p) and nth_unit_in_pos(p) == -1:
              squares_in_range.incl(p)

      var enemy_i = reachable_enemy_i(u)
      if enemy_i == -1 and squares_in_range.card() > 0: # Move only when not already in attacking range
        let prevs = breadth_first_search(u.pos)
        var paths: seq[seq[Point]] = @[]
        for target in squares_in_range:
          if target in prevs:
            var path = @[target]
            while path[^1] in prevs:
              path.add(prevs[path[^1]])
            paths.add(reversed(path)[1..^1])

        if len(paths) > 0:
          u.pos = paths.sortedByIt((len(it), it[^1].y, it[^1].x, it[0].y, it[0].x))[0][0]

      enemy_i = reachable_enemy_i(u)
      if enemy_i > -1:
        let target = units[enemy_i]
        units[enemy_i].hp.dec(if u.team == elf: ELF_ATTACK_POWER else: 3)

      var remaining_hp = toTable([(elf, 0), (goblin, 0)])
      for _, hp, team in units.items:
        # Uncomment for step 2:
        # if team == elf and hp <= 0:
        #   echo "ELF DIED at round ", round - 1, ", ATTACK POWER: ", ELF_ATTACK_POWER
        #   return -1
        if hp > 0:
          remaining_hp[team] += hp
      for team in [elf, goblin]:
        if remaining_hp[team] == 0:
          let winner = if team == elf: goblin else: elf
          echo &"Team {winner} won at round {round - 1} with {remaining_hp[winner]} HP left"
          return (round - 1) * remaining_hp[winner]


proc step2(): int =
  while true:
    ELF_ATTACK_POWER += 1
    result = step1()
    if result != -1:
      break


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
