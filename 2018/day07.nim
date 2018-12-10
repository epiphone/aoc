import algorithm
import future
import heapqueue
import sequtils
import sets
import strscans
import strformat
import tables
from times import cpuTime

type Step = tuple[before: set[char], after: set[char]]

proc read_input*(): seq[array[2, char]] =
  for line in lines("inputs/day07.txt"):
    var a, b: string
    discard scanf(line, "Step $w must be finished before step $w can begin.", a, b)
    result.add([a[0], b[0]])

func toString(chars: openArray[char]): string =
  result = newStringOfCap(len(chars))
  for c in chars:
    add(result, c)

proc step1(): string =
  var steps = initTable[char, Step]()

  for pair in read_input():
    for c in pair:
      if not (c in steps):
        steps[c] = ({}, {})
    steps[pair[0]].after.incl(pair[1])
    steps[pair[1]].before.incl(pair[0])

  var first_steps: set[char]
  for k, v in steps:
    if v.before == {}:
      first_steps.incl(k)

  func make_order(available: set[char], res: seq[char]): seq[char] =
    for c in sorted(toSeq(available.items), cmp):
      block myblock:
        let step = steps[c]
        for r in step.before:
          if not (r in res):
            break myblock
        let next_available = (available + step.after) - {c}
        return make_order(next_available, res & c)

    return res

  return toString(make_order(first_steps, @[]))


proc step1_loop_heapqueue(): string =
  var steps = initTable[char, Step]()
  for pair in read_input():
    for c in pair:
      if not (c in steps):
        steps[c] = ({}, {})
    steps[pair[0]].after.incl(pair[1])
    steps[pair[1]].before.incl(pair[0])

  var available = newHeapQueue[char]()
  var done: seq[char]
  var done_set: set[char]

  func update_available() =
    for k, v in steps:
      if v.before <= done_set:
        available.push(k)
        steps.del(k)

  update_available()

  while steps.len > 0 or available.len > 0:
    let c = available.pop()
    steps.del(c)
    done.add(c)
    done_set.incl(c)
    update_available()

  return toString(done)


proc step2(): int =
  func step_duration(c: char): int = ord(c) - 4 # 64
  var steps = initTable[char, Step]()

  for pair in read_input():
    for c in pair:
      if not (c in steps):
        steps[c] = ({}, {})
    steps[pair[0]].after.incl(pair[1])
    steps[pair[1]].before.incl(pair[0])

  var left = toSeq(steps.keys)
  sort(left, cmp)
  var workers = repeat((step: '?', time_left: 0), 5) # 2)
  var done: set[char]
  var time = 0

  while true:
    inc(time)
    for i, worker in workers:
      let (step, time_left) = worker
      if time_left == 0:
        if step != '?':
          done.incl(step)
      else:
        workers[i].time_left.dec()

    for i, worker in workers:
      let (step, time_left) = worker
      if time_left == 0:
        for j, step in left:
          if steps[step].before <= done:
            left.delete(j)
            workers[i] = (step: step, time_left: step_duration(step) - 1)
            break

    if left.len == 0 and all(workers, (w) => w.time_left == 0):
      break

  return time

when isMainModule:
  var time = cpuTime()
  echo &"Step 1: {step1()}, took {(cpuTime() - time) * 1000:2} ms"
  time = cpuTime()
  echo &"Step 1 loop + heapqueue: {step1_loop_heapqueue()}, took {(cpuTime() - time) * 1000:2} ms"
  time = cpuTime()
  echo &"Step 2: {step2()}, took {(cpuTime() - time) * 1000:2} ms"
