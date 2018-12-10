from algorithm import sort
from re import nil
from strUtils import endsWith, parseInt, split
from math import nil
import tables
from times import nil

proc steps_1_and_2() =
  var rows: seq[string]
  for row in lines("inputs/day04.txt"):
    rows.add(row)
  sort(rows, cmp)

  var minutes_asleep_per_guard = newCountTable[int]()
  var sleepiest_mins = initTable[int, array[60, int]]()
  var sleeping_since = times.now()
  var current_guard: int

  for row in rows:
    var matches: array[2, string]
    discard re.match(row, re.re"\[([\d\s:-]+)\] (.+)$", matches)
    let date = times.parse(matches[0], "yyyy-MM-dd HH:mm")

    if matches[1].endsWith("begins shift"):
      current_guard = parseInt(split(matches[1])[1][1..^1])
    elif matches[1].endsWith("falls asleep"):
      sleeping_since = date
    else: # Woke up
      let slept_minutes = times.between(sleeping_since, date).minutes

      if not minutes_asleep_per_guard.hasKey(current_guard):
        minutes_asleep_per_guard[current_guard] = slept_minutes
      else:
        inc(minutes_asleep_per_guard[current_guard], slept_minutes)

      var default_sleepiest_mins: array[60, int]
      if not sleepiest_mins.hasKey(current_guard):
        sleepiest_mins[current_guard] = default_sleepiest_mins

      if sleeping_since.minute > date.minute:
        for m in sleeping_since.minute..59:
          inc(sleepiest_mins[current_guard][m])
        for m in 0..<date.minute:
          inc(sleepiest_mins[current_guard][m])
      else:
        for m in sleeping_since.minute..<date.minute:
          inc(sleepiest_mins[current_guard][m])

  let most_asleep = minutes_asleep_per_guard.largest
  echo "The sleepiest guard ", most_asleep[0], " slept in total for ", most_asleep[1], " mins"

  # Step 2:
  var
    max_frequent_guard_id = most_asleep[0]
    max_frequent_minute = 0
  for guard_id, sleep_minutes in sleepiest_mins:
    for i, m in sleep_minutes:
      if m > sleepiest_mins[max_frequent_guard_id][max_frequent_minute]:
        max_frequent_guard_id = guard_id
        max_frequent_minute = i

  echo "Most frequent minute was for guard ", max_frequent_guard_id, ", minute ", max_frequent_minute


proc steps_1_and_2_b() =
  # Going for a neater solution. Also cuts down execution from ~22ms to ~7ms.
  var rows: seq[string]
  for row in lines("inputs/day04.txt"):
    rows.add(row)
  sort(rows, cmp)

  var guards = initTable[int, array[60, int]]()
  var current_guard: int
  var sleeping_since = times.now()

  for row in rows:
    var parts = row.split()
    var dateStr = (parts[0] & parts[1])[1..^2]
    let date = times.parse(dateStr, "yyyy-MM-ddHH:mm")

    case parts[^1]:
      of "shift":
        # New guard started a shift:
        current_guard = parseInt(parts[3][1..^1])
        if not guards.hasKey(current_guard):
          var default_minutes: array[60, int]
          guards[current_guard] = default_minutes
      of "asleep":
        # Guard fell asleep:
        sleeping_since = date
      else:
        # Guard woke up:
        if sleeping_since.minute > date.minute:
          for m in sleeping_since.minute..59:
            inc(guards[current_guard][m])
          for m in 0..<date.minute:
            inc(guards[current_guard][m])
        else:
          for m in sleeping_since.minute..<date.minute:
            inc(guards[current_guard][m])

  var top_sleeper: int
  var max_sleeper_mins = 0
  var top_frequency_sleeper: int
  var max_freq_min = 0
  var max_freq_mins_slept = 0

  for guard, minutes in guards:
    let sleeper_mins = math.sum(minutes)
    if sleeper_mins > max_sleeper_mins:
      top_sleeper = guard
      max_sleeper_mins = sleeper_mins
    for i, m in minutes:
      if m > max_freq_mins_slept:
        max_freq_mins_slept = m
        max_freq_min = i
        top_frequency_sleeper = guard


  echo "The sleepiest guard ", top_sleeper, " slept in total for ", max_sleeper_mins, " mins"
  echo "Most frequent minute was for guard ", top_frequency_sleeper, ", minute ", max_freq_min


when isMainModule:
  var time = times.cpuTime()
  steps1_and_2()
  echo "Steps 1 and 2 took: ", (times.cpuTime() - time) * 1000, " ms"
  time = times.cpuTime()
  steps1_and_2_b()
  echo "Alternative implementation took: ", (times.cpuTime() - time) * 1000, " ms"
