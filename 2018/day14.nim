import queues, strformat, strutils
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
    for r in rs.mitems:
      let steps = len(scores) + 1 + scores[r]
      for _ in countup(1, steps):
        if r == len(scores) - 1:
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
  var target: array[6, int8]
  for i, c in $INPUT:
    target[i] = int8(parseInt($c))

  var
    scores: seq[int8] = @[int8(3), 7, 1, 0, 1, 0, 1, 2, 4, 5, 1, 5, 8, 9, 1, 6, 7, 7, 9, 2]
    tail = initQueue[int8]()
    rs = [8, 4]

  for i in [int8(6), 7, 7, 9, 2]:
    tail.enqueue(i)

  proc create_new_recipes(): int8 =
    ## Add new recipes to `scores` and return the last added score.
    result = scores[rs[0]] + scores[rs[1]]
    if result >= 10:
      scores.add(1)
      scores.add(result - 10)
    else:
      scores.add(result)

  proc pick_new_current_recipe() =
    for r in rs.mitems:
      let steps = len(scores) + 1 + scores[r]
      for _ in countup(1, steps):
        if r == len(scores) - 1:
          r = 0
        else:
          r += 1

  while true:
    let latest_score = create_new_recipes()
    pick_new_current_recipe()
    if latest_score >= 10:
      discard tail.dequeue()
      discard tail.dequeue()
      tail.enqueue(1)
      tail.enqueue(latest_score - 10)
    else:
      discard tail.dequeue()
      tail.enqueue(latest_score)

    # echo scores

    block end_check:
      for i, s in tail:
        if s != target[i]:
          break end_check
      return len(scores) - 5


when isMainModule:
  var t0 = epochTime()
  # echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
  # t0 = epochTime()
  echo &"Step 2: {step2()}, took {(epochTime() - t0) * 1000:3} ms"
