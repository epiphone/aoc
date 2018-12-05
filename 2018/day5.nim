import streams
from strUtils import isUpperAscii, toUpperAscii
from times import cpuTime

func react(a: char, b: char): bool =
  return (ord(a) xor ord(b)) == 32 # courtesy of https://github.com/narimiran/AdventOfCode2018/

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
      if react(res[^1], c):
        discard res.pop()
      else:
        res.add(c)

  fs.close()

  while true:
    if react(res[^1], res[^2]):
      discard res.pop()
      discard res.pop()
    else:
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
      let diff = abs(ord(c) - ord(polymer))
      if diff == 0 or diff == 32:
        continue
      if res.len == 0:
        res.add(c)
      else:
        if react(c, res[^1]):
          discard res.pop()
        else:
          res.add(c)

    while true:
      if react(res[^1], res[^2]):
        discard res.pop()
        discard res.pop()
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
