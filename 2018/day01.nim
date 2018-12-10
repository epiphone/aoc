import sets
from strutils import parseInt

proc step1(): int =
  let input_f = open("inputs/day01.txt")
  defer: close(input_f)

  var frequency = 0
  for line in input_f.lines:
    frequency = frequency + parseInt(line)

  return frequency

proc step2(): int =
  var prev_freqs = sets.initSet[int]()
  var frequency = 0

  while true:
    let input_f = open("inputs/day01.txt")
    defer: close(input_f)

    for line in input_f.lines:
      frequency = frequency + parseInt(line)
      if prev_freqs.containsOrIncl(frequency):
        return frequency

when isMainModule:
  echo "Step 1: ", step1()
  echo "Step 2: ", step2()
