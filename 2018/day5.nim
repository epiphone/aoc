import streams
from strUtils import isUpperAscii, toUpperAscii
from times import cpuTime

proc react(a: char, b: char): bool =
  return isUpperAscii(a) != isUpperAscii(b) and toUpperAscii(a) == toUpperAscii(b)

proc step1(): int =
  var fs = newFileStream("day5input.txt")
  var res: seq[char]
  while not fs.atEnd:
    let c = fs.readChar()
    if c == '\n':
      continue
    if res == "":
      res.add(c)
    else:
      let prev_c = res.pop()
      let reacts = react(prev_c, c)
      if not reacts:
        res.add(prev_c)
        res.add(c)

  fs.close()

  while true:
    let
      c1 = res.pop()
      c2 = res.pop()
    if not react(c1, c2):
      res.add(c2)
      res.add(c1)
      break

  return len(res)

proc step2(): int =
  var input = ""
  for line in lines("day5input.txt"):
    input = line
    break

  var min_length = (id: 'a', len: -1)

  for polymer in 'a'..'z':
    var fs = newFileStream("day5input.txt")
    var res: seq[char]
    for c in input:
      if toUpperAscii(c) == toUpperAscii(polymer):
        continue
      if res.len == 0:
        res.add(c)
      else:
        let prev_c = res.pop()
        if not react(c, prev_c):
          res.add(prev_c)
          res.add(c)

    while true:
      let
        c1 = res.pop()
        c2 = res.pop()
      if not react(c1, c2):
        res.add(c2)
        res.add(c1)
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
