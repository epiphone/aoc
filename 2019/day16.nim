import sequtils, strformat, strutils
from times import epochTime

const input = "59709511599794439805414014219880358445064269099345553494818286560304063399998657801629526113732466767578373307474609375929817361595469200826872565688108197109235040815426214109531925822745223338550232315662686923864318114370485155264844201080947518854684797571383091421294624331652208294087891792537136754322020911070917298783639755047408644387571604201164859259810557018398847239752708232169701196560341721916475238073458804201344527868552819678854931434638430059601039507016639454054034562680193879342212848230089775870308946301489595646123293699890239353150457214490749319019572887046296522891429720825181513685763060659768372996371503017206185697"

func flatten*[T](arrs: seq[seq[T]]): seq[T] =
  for arr in arrs:
    result &= arr

proc step1(): int =
  const base_pattern = [0, 1, 0, -1]
  var
    phase = 0
    output: array[input.len, int]
    patterns: array[input.len, seq[int]]

  for i, n in input.pairs:
    output[i] = parseInt($n)
  for i in 0..<output.len:
    patterns[i] = base_pattern.mapIt(it.repeat(i + 1)).flatten()

  while phase < 100:
    for i in 0..<output.len:
      var item = 0
      for j in 0..<output.len: # first j items are all 0 so they can be skipped
        item += patterns[i][(j + 1) mod patterns[i].len] * output[j]

      output[i] = abs(item mod 10)

    phase += 1

  return output[0..7].mapIt($it).join().parseInt()


proc step2(): int =
  let offset = input[0..<7].parseInt()
  var
    phase = 0
    output = input.cycle(10_000).mapIt(parseInt($it))

  while phase < 100:
    var m = 0
    for i in countdown(output.len - 1, output.len div 2):
      m += output[i]
      output[i] = m mod 10

    phase += 1

  return output[offset..offset + 7].mapIt($it).join().parseInt()


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
