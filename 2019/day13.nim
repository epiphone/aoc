import algorithm, sequtils, sets, strformat, strscans, strutils, tables, rdstdin

let input = "1,380,379,385,1008,2399,848142,381,1005,381,12,99,109,2400,1101,0,0,383,1101,0,0,382,21001,382,0,1,20101,0,383,2,21102,1,37,0,1105,1,578,4,382,4,383,204,1,1001,382,1,382,1007,382,44,381,1005,381,22,1001,383,1,383,1007,383,20,381,1005,381,18,1006,385,69,99,104,-1,104,0,4,386,3,384,1007,384,0,381,1005,381,94,107,0,384,381,1005,381,108,1105,1,161,107,1,392,381,1006,381,161,1102,1,-1,384,1106,0,119,1007,392,42,381,1006,381,161,1101,0,1,384,20101,0,392,1,21101,0,18,2,21101,0,0,3,21102,138,1,0,1105,1,549,1,392,384,392,21002,392,1,1,21102,18,1,2,21102,1,3,3,21102,161,1,0,1105,1,549,1102,0,1,384,20001,388,390,1,20101,0,389,2,21101,0,180,0,1105,1,578,1206,1,213,1208,1,2,381,1006,381,205,20001,388,390,1,20101,0,389,2,21102,205,1,0,1106,0,393,1002,390,-1,390,1101,1,0,384,21002,388,1,1,20001,389,391,2,21101,0,228,0,1105,1,578,1206,1,261,1208,1,2,381,1006,381,253,20101,0,388,1,20001,389,391,2,21102,253,1,0,1106,0,393,1002,391,-1,391,1101,1,0,384,1005,384,161,20001,388,390,1,20001,389,391,2,21102,279,1,0,1105,1,578,1206,1,316,1208,1,2,381,1006,381,304,20001,388,390,1,20001,389,391,2,21102,1,304,0,1105,1,393,1002,390,-1,390,1002,391,-1,391,1102,1,1,384,1005,384,161,20102,1,388,1,20101,0,389,2,21101,0,0,3,21101,0,338,0,1105,1,549,1,388,390,388,1,389,391,389,21001,388,0,1,21001,389,0,2,21102,4,1,3,21101,365,0,0,1105,1,549,1007,389,19,381,1005,381,75,104,-1,104,0,104,0,99,0,1,0,0,0,0,0,0,333,20,15,1,1,22,109,3,22101,0,-2,1,21201,-1,0,2,21102,1,0,3,21102,1,414,0,1105,1,549,21202,-2,1,1,22102,1,-1,2,21101,429,0,0,1105,1,601,2102,1,1,435,1,386,0,386,104,-1,104,0,4,386,1001,387,-1,387,1005,387,451,99,109,-3,2106,0,0,109,8,22202,-7,-6,-3,22201,-3,-5,-3,21202,-4,64,-2,2207,-3,-2,381,1005,381,492,21202,-2,-1,-1,22201,-3,-1,-3,2207,-3,-2,381,1006,381,481,21202,-4,8,-2,2207,-3,-2,381,1005,381,518,21202,-2,-1,-1,22201,-3,-1,-3,2207,-3,-2,381,1006,381,507,2207,-3,-4,381,1005,381,540,21202,-4,-1,-1,22201,-3,-1,-3,2207,-3,-4,381,1006,381,529,21202,-3,1,-7,109,-8,2106,0,0,109,4,1202,-2,44,566,201,-3,566,566,101,639,566,566,2101,0,-1,0,204,-3,204,-2,204,-1,109,-4,2106,0,0,109,3,1202,-1,44,593,201,-2,593,593,101,639,593,593,21001,0,0,-2,109,-3,2106,0,0,109,3,22102,20,-2,1,22201,1,-1,1,21101,0,443,2,21101,0,758,3,21102,1,880,4,21101,0,630,0,1106,0,456,21201,1,1519,-2,109,-3,2105,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,2,2,0,2,2,2,2,2,2,0,2,0,0,2,0,2,2,2,2,2,0,0,2,2,2,2,2,2,0,2,0,0,0,2,0,2,0,0,0,0,0,1,1,0,2,2,2,2,2,2,2,0,2,0,2,0,2,2,2,0,2,2,2,2,2,2,2,0,2,2,2,0,2,0,0,0,0,2,0,2,2,2,2,2,0,1,1,0,2,0,0,2,2,2,0,2,2,0,0,2,0,2,2,2,2,2,2,2,2,0,2,2,2,0,0,2,2,0,2,0,2,0,2,2,2,2,2,2,0,1,1,0,2,2,2,0,0,0,2,2,2,0,0,2,2,2,0,2,2,2,2,2,0,2,0,2,0,2,2,2,0,2,2,2,0,2,2,2,2,2,2,2,0,1,1,0,2,0,2,2,2,2,2,0,2,0,2,2,2,2,2,2,2,0,2,0,2,2,0,2,2,2,2,0,2,2,2,2,2,2,2,2,2,0,0,0,0,1,1,0,0,2,2,2,2,2,2,0,2,2,2,2,2,2,2,0,2,2,2,2,2,0,0,2,2,2,2,2,2,2,0,2,2,2,0,2,2,2,2,0,0,1,1,0,2,2,2,2,0,0,2,2,0,2,0,2,2,2,2,0,2,2,2,0,2,2,2,2,2,0,2,0,2,2,0,2,2,2,2,2,2,2,2,0,0,1,1,0,2,2,0,2,0,2,0,2,2,2,2,2,0,2,0,2,2,2,2,0,0,2,2,0,2,0,2,0,2,0,2,0,2,2,2,2,0,0,2,2,0,1,1,0,2,0,2,2,2,2,2,0,2,2,0,2,2,2,0,2,2,2,0,0,2,2,0,2,0,2,2,0,2,2,2,2,0,2,2,0,0,2,2,0,0,1,1,0,0,2,2,0,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,0,2,2,2,2,2,0,2,2,0,0,2,0,0,2,2,0,2,0,0,0,1,1,0,2,2,2,2,2,2,2,2,0,0,2,0,2,2,2,2,2,2,2,2,2,2,0,2,2,2,2,0,0,2,0,0,2,2,2,2,2,2,2,0,0,1,1,0,2,0,2,0,0,2,2,0,2,0,2,0,2,0,2,2,2,0,0,2,2,2,0,0,2,2,2,0,2,0,2,0,0,2,0,0,2,2,2,2,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,49,63,55,3,42,75,44,11,52,43,19,94,25,84,91,44,85,78,73,32,40,21,13,35,50,35,1,13,10,42,58,90,30,42,52,73,65,49,6,49,20,97,15,59,60,77,89,53,16,70,77,24,6,78,18,5,32,32,82,86,80,66,80,26,57,42,45,27,13,69,43,93,22,79,42,62,36,97,23,41,66,8,4,52,75,31,14,83,21,15,93,64,45,24,41,50,37,98,96,54,66,96,53,78,78,76,43,39,60,81,96,83,14,3,89,51,8,47,66,33,29,32,83,15,37,89,81,57,46,25,45,94,70,80,94,49,6,57,61,59,42,39,45,79,63,68,93,53,65,32,87,56,76,29,70,45,72,12,13,25,67,1,32,55,31,12,96,33,28,64,33,50,53,37,22,50,42,93,64,43,56,47,96,93,22,77,17,5,69,24,88,92,17,18,84,76,4,65,90,43,11,55,60,78,52,34,45,77,10,37,30,48,21,22,52,30,25,40,72,6,12,36,87,96,94,95,78,58,69,38,61,8,29,3,43,95,65,63,24,73,24,42,18,7,7,20,8,25,78,86,21,20,23,69,72,91,54,54,23,68,19,78,79,6,31,14,7,84,21,83,55,11,42,79,94,44,5,50,43,47,40,97,86,23,16,40,64,4,62,94,90,56,87,57,90,8,32,20,75,6,68,6,39,10,92,56,1,8,4,43,22,12,7,72,3,75,25,41,26,42,74,43,64,87,6,97,58,40,35,89,94,64,17,66,61,27,68,58,76,67,94,18,54,52,3,16,94,75,23,57,22,41,66,29,97,33,89,96,82,30,32,22,49,85,46,64,62,82,47,53,1,41,7,55,33,93,33,37,69,98,28,26,48,26,9,55,5,77,60,47,70,53,44,44,43,27,94,9,13,57,9,68,43,64,44,75,13,68,67,74,82,20,24,51,36,21,32,53,37,32,87,4,2,25,22,63,53,85,31,83,51,30,40,52,27,81,83,84,17,57,18,29,17,6,94,20,85,35,23,31,21,19,68,51,11,48,74,49,22,30,22,82,60,74,92,9,26,69,75,48,85,90,85,92,34,39,23,32,39,14,9,66,92,52,34,91,49,36,64,97,15,88,11,81,84,67,98,57,18,24,52,14,19,25,21,62,37,3,51,71,41,12,19,30,13,12,18,57,42,26,84,30,43,24,76,83,19,47,35,86,82,24,31,42,35,42,76,7,58,54,76,83,50,90,81,40,74,56,7,64,58,46,88,71,49,38,52,33,50,11,43,91,38,72,9,9,58,71,74,81,81,29,75,88,23,11,15,73,81,87,43,18,93,21,45,19,46,22,29,10,52,83,38,32,52,72,8,48,34,59,59,16,7,24,17,39,29,42,36,74,53,14,42,82,49,46,68,42,97,96,94,94,44,93,25,82,7,37,31,67,16,61,41,73,23,11,10,70,21,3,94,18,88,14,32,73,95,87,35,31,13,73,42,41,43,70,60,92,44,35,18,15,71,40,75,40,16,25,79,78,7,33,2,39,2,51,6,34,58,98,69,49,2,76,98,55,76,84,53,5,8,30,61,92,43,67,38,81,86,48,64,44,81,88,3,12,5,68,25,94,54,50,85,49,53,52,54,9,80,55,53,63,72,51,83,48,49,7,96,9,43,88,85,46,6,33,75,82,2,34,70,88,15,6,83,3,90,69,95,84,52,61,38,61,4,29,87,94,11,90,62,17,21,17,14,1,83,40,1,12,69,57,67,42,39,43,82,80,14,79,74,33,61,12,20,77,3,88,52,62,82,92,22,37,76,21,69,53,5,23,72,23,39,78,50,37,89,43,65,36,62,34,35,97,23,10,68,80,23,31,69,49,81,40,20,31,56,72,19,36,95,68,64,5,12,92,64,47,73,98,94,54,79,76,76,35,16,51,14,26,72,26,7,58,20,30,47,91,86,24,30,76,64,18,84,6,57,81,67,73,33,44,33,92,44,69,27,88,6,51,848142"

type Computer* = tuple[mem: Table[int, int], inputs: seq[int], rb, ip, mode_a, mode_b, mode_c: int]

func init_computer*(ops: string, inputs: seq[int]): Computer =
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

proc process*(c: var Computer): seq[int] =
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


proc step1(): int =
  var
    computer = init_computer(input, @[])
    tiles = initHashSet[(int, int, int)]()

  while true:
    let output = process(computer)
    var i = 0
    while true:
      if i + 2 >= output.len:
        break
      tiles.incl((output[i], output[i+1], output[i+2]))
      i += 3

    if output.len == 0:
      break

  for tile in tiles:
    if tile[2] == 2:
      result += 1


proc step2(): int =
  var
    computer = init_computer(input, @[])
    tiles = initTable[(int, int), int]()

  computer.mem[0] = 2

  while true:
    let output = process(computer)

    var i = 0
    while true:
      if i + 2 >= output.len:
        break
      tiles[(output[i], output[i+1])] = output[i+2]
      i += 3

    var
      num_of_tiles = 0
      ball_pos = (0, 0)
      paddle_pos = (0, 0)

    for item, val in tiles.pairs:
      if val == 2:
        num_of_tiles += 1
      elif val == 3:
        paddle_pos = item
      elif val == 4:
        ball_pos = item

    if num_of_tiles == 0:
      break

    computer.inputs.add(if ball_pos[0] > paddle_pos[0]: 1 elif ball_pos[0] < paddle_pos[0]: -1 else: 0)

  return tiles[(-1, 0)]


when isMainModule:
  echo "Step 1: ", step1()
  echo "Step 2: ", step2()
