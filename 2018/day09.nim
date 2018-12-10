from math import floorDiv
import lists
import strformat
from times import cpuTime

const PLAYERS = 463
var LAST_MARBLE = 71787


proc step1(): int =
  var curr_player = 0
  var scores: array[PLAYERS, int]
  var marbles = initDoublyLinkedRing[int]()
  var curr_marble = newDoublyLinkedNode(0)
  marbles.append(curr_marble)

  for i in 1..LAST_MARBLE:
    if i mod 23 == 0:
      scores[curr_player].inc(i)
      for j in 0..5:
        curr_marble = curr_marble.prev

      scores[curr_player].inc(curr_marble.prev.value)
      marbles.remove(curr_marble.prev)
    else:
      let new_marble = newDoublyLinkedNode(i)
      let left = curr_marble.next
      let right = left.next
      left.next = new_marble
      right.prev = new_marble
      new_marble.next = right
      new_marble.prev = left

      curr_marble = new_marble

    curr_player = (curr_player + 1) mod PLAYERS

  return max(scores)


when isMainModule:
  var time = cpuTime()
  echo &"Step 1: {step1()}, took {(cpuTime() - time) * 1000} ms"
  LAST_MARBLE *= 100
  time = cpuTime()
  echo &"Step 2: {step1()}, took {(cpuTime() - time) * 1000} ms"
