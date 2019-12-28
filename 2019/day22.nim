import algorithm, bigints, strformat, strutils, times

# https://rosettacode.org/wiki/Modular_exponentiation#Nim
func powmod(b, e, m: BigInt): BigInt =
  assert e >= 0
  var e = e
  var b = b
  result = initBigInt(1)
  while e > 0:
    if e mod 2 == 1:
      result = (result * b) mod m
    e = e div 2
    b = (b.pow 2) mod m

proc step1(): int =
  type Deck = array[10_007, 0..10_006]
  var deck: Deck
  for i, _ in deck.pairs:
    deck[i] = i

  for instruction in lines("./input22.txt"):
    if instruction == "deal into new stack":
      deck.reverse()
    elif instruction.startsWith("cut"):
      let cut_by = instruction.split(' ')[1].parseInt()
      deck.rotateLeft(cut_by)
    else:
      let increment = instruction.split(' ')[^1].parseInt()
      var new_deck: Deck
      for i, n in deck:
        new_deck[i * increment mod deck.len] = n
      deck = new_deck

  # or (deck.find(0) + 2019 * (deck.find(1) - deck.find(0))) mod deck.len
  return deck.find(2019)


proc step2(): BigInt =
  const
    deck_size = 119315717514047.initBigInt
    shuffles_count = 101741582076661.initBigInt
    target_index = 2020.initBigInt

  func inverse(x: BigInt): BigInt = powmod(x, deck_size - 2, deck_size)

  var
    o = initBigInt(0)
    i = initBigInt(1)

  for instruction in lines("./input22.txt"):
    if instruction == "deal into new stack":
      o -= i
      i = -i
    elif instruction.startsWith("cut"):
      let cut_by = instruction.split(' ')[1].parseInt().initBigInt
      o += i * cut_by
    else:
      let increment = instruction.split(' ')[^1].parseInt().initBigInt
      i *= inverse(increment)

  o *= inverse(1.initBigInt - i)
  i = powmod(i, shuffles_count, deck_size)

  return (target_index * i + (1.initBigInt - i) * o) mod deck_size


when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
