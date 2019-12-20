import algorithm, sequtils, sets, strutils, tables

let input = "3,8,1005,8,301,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,102,1,8,28,1006,0,98,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,54,2,1001,6,10,1,108,1,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,1002,8,1,84,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,101,0,8,105,1006,0,94,2,7,20,10,2,5,7,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,102,1,8,139,1006,0,58,2,1003,16,10,1,6,10,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,102,1,8,172,2,107,12,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,101,0,8,197,1006,0,34,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,102,1,8,223,1006,0,62,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,1001,8,0,248,1,7,7,10,1006,0,64,2,1008,5,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,102,1,8,280,101,1,9,9,1007,9,997,10,1005,10,15,99,109,623,104,0,104,1,21102,1,387508351636,1,21101,318,0,0,1106,0,422,21102,1,838480007948,1,21101,0,329,0,1106,0,422,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21101,0,235190525123,1,21101,0,376,0,1105,1,422,21101,0,106505084123,1,21101,0,387,0,1106,0,422,3,10,104,0,104,0,3,10,104,0,104,0,21101,0,838324605292,1,21102,1,410,0,1105,1,422,21102,709496668940,1,1,21102,421,1,0,1105,1,422,99,109,2,22101,0,-1,1,21102,1,40,2,21101,0,453,3,21102,443,1,0,1106,0,486,109,-2,2105,1,0,0,1,0,0,1,109,2,3,10,204,-1,1001,448,449,464,4,0,1001,448,1,448,108,4,448,10,1006,10,480,1102,1,0,448,109,-2,2106,0,0,0,109,4,2101,0,-1,485,1207,-3,0,10,1006,10,503,21102,0,1,-3,22102,1,-3,1,21201,-2,0,2,21101,1,0,3,21102,1,522,0,1106,0,527,109,-4,2105,1,0,109,5,1207,-3,1,10,1006,10,550,2207,-4,-2,10,1006,10,550,21202,-4,1,-4,1106,0,618,22102,1,-4,1,21201,-3,-1,2,21202,-2,2,3,21102,569,1,0,1106,0,527,21202,1,1,-4,21101,0,1,-1,2207,-4,-2,10,1006,10,588,21101,0,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,610,22101,0,-1,1,21101,0,610,0,106,0,485,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2106,0,0"

type Computer = tuple[mem: Table[int, int], inputs: seq[int], rb, ip, mode_a, mode_b, mode_c: int]

func init_computer(ops: string, inputs: seq[int]): Computer =
  result.inputs = inputs.reversed() # reverse for `pop()`ing
  for i, op in ops.split(',').map(parseInt).pairs:
    result.mem[i] = op

proc read_opcode(c: var Computer): int =
  let op = c.mem[c.ip]
  c.mode_c = op div 10_000
  c.mode_b = (op - c.mode_c * 10_000) div 1000
  c.mode_a = (op - c.mode_c * 10_000 - c.mode_b * 1000) div 100
  return op mod 100

func addr1(c: Computer): int =
  if c.mode_a == 0: c.mem[c.ip + 1] elif c.mode_a == 1: c.ip + 1 else: c.rb + c.mem[c.ip + 1]
func addr2(c: Computer): int =
  if c.mode_b == 0: c.mem[c.ip + 2] elif c.mode_b == 1: c.ip + 2 else: c.rb + c.mem[c.ip + 2]
func addr3(c: Computer): int =
  if c.mode_c == 0: c.mem[c.ip + 3] elif c.mode_c == 1: c.ip + 3 else: c.rb + c.mem[c.ip + 3]

func read1(c: Computer): int = c.mem.getOrDefault(c.addr1)
func read2(c: Computer): int = c.mem.getOrDefault(c.addr2)
func read3(c: Computer): int = c.mem.getOrDefault(c.addr3)

proc process(c: var Computer): seq[int] =
  while true:
    case read_opcode(c)
    of 1:
      c.mem[c.addr3] = c.read1() + c.read2()
      c.ip += 4
    of 2:
      c.mem[c.addr3] = c.read1() * c.read2()
      c.ip += 4
    of 3:
      if c.inputs.len == 0:
        break
      c.mem[c.addr1] = c.inputs.pop()
      c.ip += 2
    of 4:
      result.add(c.read1())
      c.ip += 2
    of 5:
      c.ip = if c.read1() == 0: c.ip + 3 else: c.read2()
    of 6:
      c.ip = if c.read1() == 0: c.read2() else: c.ip + 3
    of 7:
      c.mem[c.addr3] = if c.read1() < c.read2(): 1 else: 0
      c.ip += 4
    of 8:
      c.mem[c.addr3] = if c.read1() == c.read2(): 1 else: 0
      c.ip += 4
    of 9:
      c.rb += c.read1()
      c.ip += 2
    of 99:
      break
    else:
      raise newException(Exception, "Invalid operation")

type Dir* = enum Up, Right, Down, Left

func turn*(dir, to_dir: Dir): Dir =
  if to_dir == Left:
    if dir == Up: Left elif dir == Left: Down elif dir == Down: Right else: Up
  else:
    if dir == Up: Right elif dir == Right: Down elif dir == Down: Left else: Up

proc step1(): int =
  var
    computer = init_computer(input, @[])
    pos = (0, 0)
    dir: Dir = Up
    white_panels = initHashSet[(int, int)]()
    painted_panels = initHashSet[(int, int)]()

  while true:
    computer.inputs = @[if pos in white_panels: 1 else: 0]
    let output = process(computer)
    if output.len == 0:
      break

    if output[0] == 0:
      white_panels.excl(pos)
    else:
      white_panels.incl(pos)

    painted_panels.incl(pos)

    dir = turn(dir, if output[1] == 0: Left else: Right)

    pos[0] += (if dir in {Up, Down}: 0 elif dir == Right: 1 else: -1)
    pos[1] += (if dir in {Right, Left}: 0 elif dir == Down: 1 else: -1)

  return painted_panels.len


proc step2(): int =
  var
    computer = init_computer(input, @[])
    pos = (0, 0)
    dir: Dir = Up
    white_panels = initHashSet[(int, int)]()
    painted_panels = initHashSet[(int, int)]()

  white_panels.incl(pos)

  while true:
    computer.inputs = @[if pos in white_panels: 1 else: 0]
    let output = process(computer)
    if output.len == 0:
      break

    if output[0] == 0:
      white_panels.excl(pos)
    else:
      white_panels.incl(pos)

    painted_panels.incl(pos)

    dir = turn(dir, if output[1] == 0: Left else: Right)

    pos[0] += (if dir in {Up, Down}: 0 elif dir == Right: 1 else: -1)
    pos[1] += (if dir in {Right, Left}: 0 elif dir == Down: 1 else: -1)

  var min_x, max_x, min_y, max_y: int
  for (x, y) in white_panels:
    min_x = min(min_x, x)
    max_x = max(max_x, x)
    min_y = min(min_y, y)
    max_y = max(max_y, y)

  for y in min_y..max_y:
    echo mapIt(min_x..max_x, if (it, y) in white_panels: '#' else: ' ').join()


when isMainModule:
  echo "Step 1: ", step1()
  echo "Step 2: ", step2()
