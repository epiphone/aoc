import algorithm
import sequtils
import strformat
import strutils
from times import cpuTime

proc read_input(): seq[int] =
  for line in lines("day8input.txt"):
    return line.split().map(parseInt)

proc step1(): int =
  var nums = read_input()
  reverse(nums)
  var metadata_sum = 0

  func parse_node() =
    let children_n = nums.pop()
    let metadata_n = nums.pop()

    for children in 0..<children_n:
      parse_node()
    for metadata in 0..<metadata_n:
      metadata_sum.inc(nums.pop())

  parse_node()

  return metadata_sum

proc step2(): int =
  var nums = read_input()
  reverse(nums)

  func node_value(): int =
    let children_n = nums.pop()
    let metadata_n = nums.pop()

    var child_values: seq[int]
    for child in 0..<children_n:
      child_values.add(node_value())

    var metadata_values: seq[int]
    for metadata in 0..<metadata_n:
      metadata_values.add(nums.pop())

    if children_n == 0:
      for metadata in metadata_values:
        result.inc(metadata)
    else:
      for metadata in metadata_values:
        if metadata <= children_n:
          result.inc(child_values[metadata - 1])

  return node_value()

when isMainModule:
  var time = cpuTime()
  echo &"Step 1: {step1()}, took {(cpuTime() - time) * 1000:2} ms"
  time = cpuTime()
  echo &"Step 2: {step2()}, took {(cpuTime() - time) * 1000:2} ms"
