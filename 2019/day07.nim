from algorithm import nextPermutation, reversed
from sequtils import concat, map, toSeq
from strutils import align, parseInt, split, startsWith

let input = "3,8,1001,8,10,8,105,1,0,0,21,46,59,84,93,102,183,264,345,426,99999,3,9,1002,9,4,9,1001,9,3,9,102,2,9,9,1001,9,5,9,102,3,9,9,4,9,99,3,9,1002,9,3,9,101,4,9,9,4,9,99,3,9,1002,9,4,9,1001,9,4,9,102,2,9,9,1001,9,2,9,1002,9,3,9,4,9,99,3,9,1001,9,5,9,4,9,99,3,9,1002,9,4,9,4,9,99,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,99"

func process(opcodes: seq[int], inputs: (int, int)): int =
  var
    ip = 0
    ops = opcodes
    inputs_consumed = 0

  while true:
    let
      padded_op = align($ops[ip], 5, '0')
      opcode = parseInt(padded_op[3..^1])

    proc read_input(index: int): int =
      if padded_op[2 - index] == '0': ops[ops[ip + 1 + index]] else: ops[ip + 1 + index]

    case opcode
    of 1:
      ops[ops[ip + 3]] = read_input(0) + read_input(1)
      ip += 4
    of 2:
      ops[ops[ip + 3]] = read_input(0) * read_input(1)
      ip += 4
    of 3:
      let input = if inputs_consumed == 0: inputs[0] else: inputs[1]
      inputs_consumed += 1
      ops[ops[ip + 1]] = input
      ip += 2
    of 4:
      result = ops[ops[ip + 1]]
      ip += 2
    of 99:
      break
    of 5:
      ip = if read_input(0) != 0: read_input(1) else: ip + 3
    of 6:
      ip = if read_input(0) == 0: read_input(1) else: ip + 3
    of 7:
      ops[ops[ip + 3]] = if read_input(0) < read_input(1): 1 else: 0
      ip += 4
    of 8:
      ops[ops[ip + 3]] = if read_input(0) == read_input(1): 1 else: 0
      ip += 4
    else:
      raise newException(Exception, "invalid opcode: " & $opcode)

func permutations(): seq[array[5, int]] =
  var arr = [0, 1, 2, 3, 4]
  result.add(arr)
  while nextPermutation(arr):
    result.add(arr)

proc step1(): int =
  let opcodes = input.split(',').map(parseInt)

  for inputs in permutations():
    var output = 0
    for i in inputs:
      output = process(opcodes, (i, output))

    if output > result:
      result = output


when isMainModule:
  echo "Step 1: ", step1()
