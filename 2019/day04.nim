from strutils import parseInt, split, startsWith

let input = [271973, 785961]

proc step1(): int =
  for i in input[0]..input[1]:
    let stri = $i
    var
      has_pair = false
      decreases = true

    for index, c in stri.pairs:
      if index == 0:
        continue
      if c == stri[index - 1]:
        has_pair = true
      if parseInt($c) < parseInt($stri[index - 1]):
        decreases = false
        break

    if decreases and has_pair:
      result += 1


proc step2(): int =
  for i in input[0]..input[1]:
    let stri = $i
    var
      current_pair_len = 1
      decreases = true
      pair_lens: seq[int] = @[]

    for index, c in stri.pairs:
      if index == 0:
        continue
      if c == stri[index - 1]:
        current_pair_len += 1
      else:
        pair_lens.add(current_pair_len)
        current_pair_len = 1

      if parseInt($c) < parseInt($stri[index - 1]):
        decreases = false
        break

    pair_lens.add(current_pair_len)

    if decreases and pair_lens.contains(2):
      result += 1


when isMainModule:
  echo "Step 1: ", step1()
  echo "Step 2: ", step2()
