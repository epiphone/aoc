import sets, strformat, strscans
from times import epochTime


type
  Instr = array[4, int]
  Register = array[6, int]

const OP_INDEXES = ["addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori", "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr"]

proc read_input(): (int, seq[Instr]) =
  result[0] = -1
  for line in lines("inputs/day21.txt"):
    if result[0] == -1:
      var instruction_pointer: int
      discard scanf(line, "#ip $i", instruction_pointer)
      result[0] = instruction_pointer
    else:
      var
        op: string
        a, b, c: int
      discard scanf(line, "$w $i $i $i", op, a, b, c)
      let op_index = OP_INDEXES.find(op)
      assert op_index >= 0
      result[1].add([op_index, a, b, c])

func op_addr(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = r[i[1]] + r[i[2]]

func op_addi(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = r[i[1]] + i[2]

func op_mulr(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = r[i[1]] * r[i[2]]

func op_muli(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = r[i[1]] * i[2]

func op_banr(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = r[i[1]] and r[i[2]]

func op_bani(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = r[i[1]] and i[2]

func op_borr(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = r[i[1]] or r[i[2]]

func op_bori(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = r[i[1]] or i[2]

func op_setr(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = r[i[1]]

func op_seti(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = i[1]

func op_gtir(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = int(i[1] > r[i[2]])

func op_gtri(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = int(r[i[1]] > i[2])

func op_gtrr(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = int(r[i[1]] > r[i[2]])

func op_eqir(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = int(i[1] == r[i[2]])

func op_eqri(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = int(r[i[1]] == i[2])

func op_eqrr(r: Register, i: Instr): Register =
  result = r
  result[i[3]] = int(r[i[1]] == r[i[2]])

const OPS* = [op_addr, op_addi, op_mulr, op_muli, op_banr, op_bani, op_borr, op_bori, op_setr, op_seti, op_gtir, op_gtri, op_gtrr, op_eqir, op_eqri, op_eqrr]

proc steps1_and_2(): int =
  let (ip, instructions) = read_input()
  var register: Register = [0, 0, 0, 0, 0, 0]
  var r4s = initSet[int]()

  while true:
    let instr_i = register[ip]
    let instr: Instr = instructions[register[ip]]
    let operation = OPS[instr[0]]
    let prev_register = register
    register = operation(register, instr)
    register[ip].inc()

    # Step 1: return the value of register 4 when the program first gets to instruction 28:
    # if instr_i == 28:
    #   return register[4]

    # Step 2: return the last value of register 4 before they start repeating themselves:
    if instr_i == 28:
      if not (register[4] in r4s):
        result = register[4]
        r4s.incl(register[4])
      else:
        return result

when isMainModule:
  var t0 = epochTime()
  echo &"Steps 1 and 2: {steps1_and_2()}, took {(epochTime() - t0) * 1000:3} ms"
