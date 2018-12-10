import tables

proc step1(): int =
  let input_f = open("inputs/day02.txt")
  defer: close(input_f)

  var
    doubles_n = 0
    triples_n = 0

  for line in input_f.lines():
    let char_counts = tables.newCountTable[char]()
    for c in line:
      char_counts.inc(c)

    var counts: set[int8]
    for v in char_counts.values:
      counts.incl(int8(v))
    if counts.contains(2):
      doubles_n = doubles_n + 1
    if counts.contains(3):
      triples_n = triples_n + 1

  return doubles_n * triples_n

proc step2(): string =
  var rows: seq[string]
  let input_f = open("inputs/day02.txt")
  for line in input_f.lines:
    rows.add(line)
  close(input_f)

  for i in 0..<len(rows):
    for j in i + 1..<len(rows):
      let
        w1 = rows[i]
        w2 = rows[j]
      var errors = 0

      for c in 0..<len(w1):
        if w1[c] != w2[c]:
          errors = errors + 1
          if errors >= 2:
            break

      if errors == 1:
        var res = ""
        for c in 0..<len(w1):
          if w1[c] == w2[c]:
            res = res & w1[c]
        return res

  return ""

when isMainModule:
  echo "Step 1: ", step1()
  echo "Step 2: ", step2()
