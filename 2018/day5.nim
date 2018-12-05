import streams
from strUtils import isUpperAscii, toUpperAscii
from times import cpuTime

proc react(a: char, b: char): bool =
  return isUpperAscii(a) != isUpperAscii(b) and toUpperAscii(a) == toUpperAscii(b)

proc step1(): int =
  var fs = newFileStream("day5input.txt")
  var res = ""
  while not fs.atEnd:
    let c = fs.readChar()
    if c == '\n':
      continue
    if res == "":
      res.add(c)
    else:
      let prev_c = res[^1]
      let reacts = react(prev_c, c)
      if reacts:
        res = res[0..^2]
      else:
        res.add(c)

  while true:
    if react(res[^1], res[^2]):
      res = res[0..^3]
    else:
      break
  fs.close()

  return len(res)

proc step2(): int =
  var input = ""
  for line in lines("day5input.txt"):
    input = line
    break

  var min_length = (id: 'a', len: -1)

  for polymer in 'a'..'z':
    var fs = newFileStream("day5input.txt")
    var res = ""
    for c in input:
      if toUpperAscii(c) == toUpperAscii(polymer):
        continue
      if res == "":
        res.add(c)
      else:
        if react(c, res[^1]):
          res = res[0..^2]
        else:
          res.add(c)

    while true:
      if react(res[^1], res[^2]):
        res = res[0..^3]
      else:
        break

    echo "Polymer length ", res.len, " when removing ", polymer
    if min_length.len == -1 or min_length.len > res.len:
      min_length = (id: polymer, len: res.len)

  echo "Shortest polymer: ", min_length # 4212
  return min_length.len

when isMainModule:
  var time = cpuTime()
  echo "Step 1: ", step1(), " took ", (cpuTime() - time) * 1000, " ms"
  time = cpuTime()
  echo "Step 2: ", step2(), " took ", (cpuTime() - time) * 1000, " ms"
