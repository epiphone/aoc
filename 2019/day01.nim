from strutils import parseInt

proc read_input(): seq[int] =
  for line in lines("./input01.txt"):
    result.add(parseInt(line))

func fuel(mass: int): int = (mass div 3) - 2

proc step1(): int =
  for mass in read_input():
    result += (mass div 3) - 2

proc step2(): int =
  for mass in read_input():
    var fuel_req = fuel(mass)
    while fuel_req > 0:
      result += fuel_req
      fuel_req = fuel(fuel_req)

when isMainModule:
  echo "Step 1: ", step1()
  echo "Step 2: ", step2()
