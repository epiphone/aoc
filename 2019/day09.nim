import algorithm, sequtils, strutils, tables

let input = "1102,34463338,34463338,63,1007,63,34463338,63,1005,63,53,1102,1,3,1000,109,988,209,12,9,1000,209,6,209,3,203,0,1008,1000,1,63,1005,63,65,1008,1000,2,63,1005,63,904,1008,1000,0,63,1005,63,58,4,25,104,0,99,4,0,104,0,99,4,17,104,0,99,0,0,1102,533,1,1024,1102,260,1,1023,1101,33,0,1016,1102,37,1,1017,1102,1,36,1009,1101,0,35,1011,1101,0,27,1004,1101,0,0,1020,1101,242,0,1029,1101,0,31,1018,1101,0,38,1007,1101,0,29,1015,1102,1,23,1006,1101,25,0,1002,1102,1,39,1008,1101,0,20,1001,1102,1,34,1012,1102,370,1,1027,1101,30,0,1010,1102,24,1,1014,1101,21,0,1000,1101,22,0,1003,1102,1,26,1005,1101,0,267,1022,1101,1,0,1021,1101,28,0,1013,1101,0,32,1019,1101,251,0,1028,1101,377,0,1026,1102,1,524,1025,109,4,2102,1,-4,63,1008,63,21,63,1005,63,203,4,187,1105,1,207,1001,64,1,64,1002,64,2,64,109,6,1201,-1,0,63,1008,63,36,63,1005,63,229,4,213,1105,1,233,1001,64,1,64,1002,64,2,64,109,18,2106,0,0,4,239,1001,64,1,64,1106,0,251,1002,64,2,64,109,-4,2105,1,-1,1001,64,1,64,1105,1,269,4,257,1002,64,2,64,109,-6,1205,3,287,4,275,1001,64,1,64,1106,0,287,1002,64,2,64,109,-19,1202,9,1,63,1008,63,41,63,1005,63,307,1105,1,313,4,293,1001,64,1,64,1002,64,2,64,109,8,2108,23,-1,63,1005,63,331,4,319,1106,0,335,1001,64,1,64,1002,64,2,64,109,-3,21101,40,0,10,1008,1014,40,63,1005,63,361,4,341,1001,64,1,64,1106,0,361,1002,64,2,64,109,28,2106,0,-5,1001,64,1,64,1106,0,379,4,367,1002,64,2,64,109,-30,1208,7,36,63,1005,63,401,4,385,1001,64,1,64,1105,1,401,1002,64,2,64,109,-1,2101,0,6,63,1008,63,38,63,1005,63,427,4,407,1001,64,1,64,1105,1,427,1002,64,2,64,109,7,1207,-3,27,63,1005,63,445,4,433,1106,0,449,1001,64,1,64,1002,64,2,64,109,8,21107,41,40,0,1005,1016,465,1106,0,471,4,455,1001,64,1,64,1002,64,2,64,109,6,21107,42,43,-6,1005,1016,489,4,477,1105,1,493,1001,64,1,64,1002,64,2,64,109,-26,1208,8,28,63,1005,63,513,1001,64,1,64,1105,1,515,4,499,1002,64,2,64,109,29,2105,1,-1,4,521,1001,64,1,64,1105,1,533,1002,64,2,64,109,-16,1201,-4,0,63,1008,63,23,63,1005,63,553,1105,1,559,4,539,1001,64,1,64,1002,64,2,64,109,4,21101,43,0,-3,1008,1010,41,63,1005,63,579,1106,0,585,4,565,1001,64,1,64,1002,64,2,64,109,-8,1207,-3,24,63,1005,63,605,1001,64,1,64,1106,0,607,4,591,1002,64,2,64,109,1,2102,1,-2,63,1008,63,25,63,1005,63,627,1106,0,633,4,613,1001,64,1,64,1002,64,2,64,109,4,2108,25,-7,63,1005,63,653,1001,64,1,64,1106,0,655,4,639,1002,64,2,64,109,16,21102,44,1,-8,1008,1018,44,63,1005,63,681,4,661,1001,64,1,64,1106,0,681,1002,64,2,64,109,-32,1202,9,1,63,1008,63,22,63,1005,63,703,4,687,1105,1,707,1001,64,1,64,1002,64,2,64,109,1,2107,26,9,63,1005,63,725,4,713,1105,1,729,1001,64,1,64,1002,64,2,64,109,21,1206,5,745,1001,64,1,64,1106,0,747,4,735,1002,64,2,64,109,3,1205,1,763,1001,64,1,64,1106,0,765,4,753,1002,64,2,64,109,-18,2101,0,5,63,1008,63,24,63,1005,63,785,1105,1,791,4,771,1001,64,1,64,1002,64,2,64,109,6,21102,45,1,4,1008,1011,48,63,1005,63,811,1106,0,817,4,797,1001,64,1,64,1002,64,2,64,109,5,21108,46,46,1,1005,1013,835,4,823,1106,0,839,1001,64,1,64,1002,64,2,64,109,-5,21108,47,45,8,1005,1015,855,1105,1,861,4,845,1001,64,1,64,1002,64,2,64,109,9,1206,4,875,4,867,1105,1,879,1001,64,1,64,1002,64,2,64,109,-7,2107,23,-6,63,1005,63,895,1106,0,901,4,885,1001,64,1,64,4,64,99,21101,27,0,1,21101,915,0,0,1106,0,922,21201,1,51547,1,204,1,99,109,3,1207,-2,3,63,1005,63,964,21201,-2,-1,1,21101,942,0,0,1106,0,922,22102,1,1,-1,21201,-2,-3,1,21102,1,957,0,1106,0,922,22201,1,-1,-2,1106,0,968,21202,-2,1,-2,109,-3,2105,1,0"

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

proc process(c: var Computer): int =
  while true:
    case read_opcode(c)
    of 1:
      c.mem[c.addr3] = c.read1() + c.read2()
      c.ip += 4
    of 2:
      c.mem[c.addr3] = c.read1() * c.read2()
      c.ip += 4
    of 3:
      c.mem[c.addr1] = c.inputs.pop()
      c.ip += 2
    of 4:
      result = c.read1()
      echo result
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
  var computer = init_computer(input, @[1])
  return process(computer)

proc step2(): int =
  var computer = init_computer(input, @[2])
  return process(computer)

when isMainModule:
  echo "Step 1: ", step1()
  echo "Step 2: ", step2()
