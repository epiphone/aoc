import strformat, strscans
from times import epochTime


type
  Instr = array[4, int]
  Register = array[6, int]

proc read_input(): (int, seq[Instr]) =
  result[0] = -1
  let op_indexes = ["addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori", "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr"]
  for line in lines("inputs/day19.txt"):
    if result[0] == -1:
      var instruction_pointer: int
      discard scanf(line, "#ip $i", instruction_pointer)
      result[0] = instruction_pointer
    else:
      var
        op: string
        a, b, c: int
      discard scanf(line, "$w $i $i $i", op, a, b, c)
      let op_index = op_indexes.find(op)
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

proc step1(): int =
  let (instruction_pointer, instructions) = read_input()

  var register: Register = [0, 0, 0, 0, 0, 0]
  while true:
    let instr: Instr = instructions[register[instruction_pointer]]
    let operation = OPS[instr[0]]
    let prev_register = register
    register = operation(register, instr)
    register[instruction_pointer].inc()
    if register[instruction_pointer] >= len(instructions):
      return register[0]

when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"

  # Step 2 is eyeballed by scanning iteration results: turns out the program tries
  # to calculate the sum of factors of the number in register 4, with the result
  # eventually appearing in register 0.
