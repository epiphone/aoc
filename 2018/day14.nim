import lists, strformat, strutils
from times import epochTime


const INPUT = 409551

proc step1(): string =
  var
    scores: seq[int8] = @[int8(3), 7]
    rs = [0, 1]

  proc create_new_recipes() =
    let total_score = scores[rs[0]] + scores[rs[1]]
    if total_score >= 10:
      scores.add(1)
      scores.add(total_score - 10)
    else:
      scores.add(total_score)

  proc pick_new_current_recipe() =
    let n = len(scores)
    for r in rs.mitems:
      var steps = n + 1 + scores[r]
      while steps >= n:
        steps -= n
      for _ in countup(1, steps):
        if r == n - 1:
          r = 0
        else:
          r += 1

  for _ in countup(1, INPUT + 10):
    create_new_recipes()
    pick_new_current_recipe()

  result = newStringOfCap(10)
  for s in scores[INPUT..<INPUT + 10]:
    result.add(s)


proc step2(): int =
  var target: array[len($INPUT), int8]
  for i, c in $INPUT:
    target[len(target) - 1 - i] = int8(parseInt($c))

  var
    scores = initDoublyLinkedList[int8]()
    elves: array[2, DoublyLinkedNode[int8]]
    n = 0

  for i, s in [int8(3), 7, 1, 0, 1, 0, 1, 2, 4, 5, 1, 5, 8, 9, 1, 6, 7, 7, 9, 2]:
    let node = newDoublyLinkedNode(s)
    scores.append(node)
    if i == 8:
      elves[0] = node
    elif i == 4:
      elves[1] = node
    n += 1

  proc create_new_recipes() =
    let new_score = elves[0].value + elves[1].value
    if new_score >= 10:
      scores.append(1)
      scores.append(new_score - 10)
      n += 2
    else:
      scores.append(new_score)
      n += 1

  proc pick_new_current_recipe() =
    for e in elves.mitems:
      var steps = n + 1 + e.value
      while steps >= n:
        steps -= n
      for _ in countup(1, steps):
        e = if e == scores.tail: scores.head else: e.next

  while true:
    create_new_recipes()
    pick_new_current_recipe()

    block end_check:
      var node = scores.tail.prev
      for c in target:
        if c != node.value:
          break end_check
        node = node.prev
      return n - len(target) - 1

when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
