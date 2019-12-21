import strformat, times
from ./day13 import init_computer, process

let input = "109,424,203,1,21101,11,0,0,1106,0,282,21102,1,18,0,1105,1,259,1202,1,1,221,203,1,21101,0,31,0,1105,1,282,21102,1,38,0,1106,0,259,21001,23,0,2,22102,1,1,3,21102,1,1,1,21102,57,1,0,1106,0,303,2101,0,1,222,21002,221,1,3,21001,221,0,2,21101,0,259,1,21101,80,0,0,1105,1,225,21101,158,0,2,21101,0,91,0,1106,0,303,1201,1,0,223,20102,1,222,4,21101,259,0,3,21101,225,0,2,21102,225,1,1,21101,118,0,0,1106,0,225,20102,1,222,3,21101,0,79,2,21102,1,133,0,1106,0,303,21202,1,-1,1,22001,223,1,1,21101,148,0,0,1105,1,259,2102,1,1,223,21001,221,0,4,20102,1,222,3,21101,16,0,2,1001,132,-2,224,1002,224,2,224,1001,224,3,224,1002,132,-1,132,1,224,132,224,21001,224,1,1,21101,0,195,0,106,0,108,20207,1,223,2,20101,0,23,1,21102,-1,1,3,21102,214,1,0,1106,0,303,22101,1,1,1,204,1,99,0,0,0,0,109,5,1201,-4,0,249,21202,-3,1,1,21201,-2,0,2,22101,0,-1,3,21101,250,0,0,1106,0,225,21202,1,1,-4,109,-5,2105,1,0,109,3,22107,0,-2,-1,21202,-1,2,-1,21201,-1,-1,-1,22202,-1,-2,-2,109,-3,2106,0,0,109,3,21207,-2,0,-1,1206,-1,294,104,0,99,21202,-2,1,-2,109,-3,2106,0,0,109,5,22207,-3,-4,-1,1206,-1,346,22201,-4,-3,-4,21202,-3,-1,-1,22201,-4,-1,2,21202,2,-1,-1,22201,-4,-1,1,22101,0,-2,3,21102,343,1,0,1106,0,303,1106,0,415,22207,-2,-3,-1,1206,-1,387,22201,-3,-2,-3,21202,-2,-1,-1,22201,-3,-1,3,21202,3,-1,-1,22201,-3,-1,2,22101,0,-4,1,21101,384,0,0,1105,1,303,1105,1,415,21202,-4,-1,-4,22201,-4,-3,-4,22202,-3,-2,-2,22202,-2,-4,-4,22202,-3,-2,-3,21202,-4,-1,-2,22201,-3,-2,1,21202,1,1,-4,109,-5,2106,0,0"

proc step1(): int =
  for y in 0..49:
    for x in 0..49:
      var computer = init_computer(input, @[x, y])
      result += computer.process()[0]


proc step2(): int =
  proc beam_at(x, y: int): bool =
    var computer = init_computer(input, @[x, y])
    return computer.process()[0] == 1

  var
    x = 22
    y = 29

  while true:
    while true:
      if beam_at(x + 1, y):
        x += 1
      else:
        break

    if beam_at(x - 99, y + 99):
      return (x - 99) * 10_000 + y

    y += 1


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
