import sequtils, streams, strscans, strformat, strutils, sugar
from times import epochTime


type
  Register = array[4, int]
  Op = (Register, Register) -> Register
  Sample = tuple[before, instruction, after: Register]

proc read_input(): (seq[Sample], seq[Register]) =
  let fs = newFileStream("inputs/day16.txt")
  while true:
    let before = fs.readLine()
    if not before.startsWith("Before:"):
      while not fs.atEnd():
        let line = fs.readLine()
        if line != "":
          var i1, i2, i3, i4: int
          discard scanf(line, "$i $i $i $i", i1, i2, i3, i4)
          result[1].add([i1, i2, i3, i4])
      fs.close()
      return result
    let instruction = fs.readLine()
    let after = fs.readLine()
    discard fs.readLine()

    var b1, b2, b3, b4, i1, i2, i3, i4, a1, a2, a3, a4: int
    discard scanf(before, "Before: [$i, $i, $i, $i]", b1, b2, b3, b4)
    discard scanf(instruction, "$i $i $i $i", i1, i2, i3, i4)
    discard scanf(after, "After:  [$i, $i, $i, $i]", a1, a2, a3, a4)
    result[0].add(([b1, b2, b3, b4], [i1, i2, i3, i4], [a1, a2, a3, a4]))


func op_addr(r: Register, i: Register): Register =
  result = r
  result[i[3]] = r[i[1]] + r[i[2]]

func op_addi(r: Register, i: Register): Register =
  result = r
  result[i[3]] = r[i[1]] + i[2]

func op_mulr(r: Register, i: Register): Register =
  result = r
  result[i[3]] = r[i[1]] * r[i[2]]

func op_muli(r: Register, i: Register): Register =
  result = r
  result[i[3]] = r[i[1]] * i[2]

func op_banr(r: Register, i: Register): Register =
  result = r
  result[i[3]] = r[i[1]] and r[i[2]]

func op_bani(r: Register, i: Register): Register =
  result = r
  result[i[3]] = r[i[1]] and i[2]

func op_borr(r: Register, i: Register): Register =
  result = r
  result[i[3]] = r[i[1]] or r[i[2]]

func op_bori(r: Register, i: Register): Register =
  result = r
  result[i[3]] = r[i[1]] or i[2]

func op_setr(r: Register, i: Register): Register =
  result = r
  result[i[3]] = r[i[1]]

func op_seti(r: Register, i: Register): Register =
  result = r
  result[i[3]] = i[1]

func op_gtir(r: Register, i: Register): Register =
  result = r
  result[i[3]] = int(i[1] > r[i[2]])

func op_gtri(r: Register, i: Register): Register =
  result = r
  result[i[3]] = int(r[i[1]] > i[2])

func op_gtrr(r: Register, i: Register): Register =
  result = r
  result[i[3]] = int(r[i[1]] > r[i[2]])

func op_eqir(r: Register, i: Register): Register =
  result = r
  result[i[3]] = int(i[1] == r[i[2]])

func op_eqri(r: Register, i: Register): Register =
  result = r
  result[i[3]] = int(r[i[1]] == i[2])

func op_eqrr(r: Register, i: Register): Register =
  result = r
  result[i[3]] = int(r[i[1]] == r[i[2]])

const OPS* = [op_addr, op_addi, op_mulr, op_muli, op_banr, op_bani, op_borr, op_bori, op_setr, op_seti, op_gtir, op_gtri, op_gtrr, op_eqir, op_eqri, op_eqrr]


proc matching_ops(sample: Sample): set[int8] =
  for i, f in OPS:
    if f(sample.before, sample.instruction) == sample.after:
      result.incl(i)

proc step1(): int =
  let samples = read_input()[0]

  for s in samples:
    if matching_ops(s).card() >= 3:
      result += 1


proc step2(): int =
  # Eyeballing the mapping from opcode to instruction:
  let samples = read_input()[0]
  var op_code_to_func_index: array[16, int]
  for sample in samples:
    let ops = matching_ops(sample)
    if ops.card() == 1:
      op_code_to_func_index[sample.instruction[0]] = toSeq(ops.items)[0]
  echo op_code_to_func_index
  let op_to_func_i: array[16, int] = [9, 13, 8, 10, 1, 3, 2, 12, 5, 11, 7, 4, 6, 14, 15, 0]

  let instructions = read_input()[1]
  var register = [0, 0, 0, 0]
  for i in instructions:
    register = OPS[op_to_func_i[i[0]]](register, i)
  return register[0]


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
