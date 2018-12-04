from algorithm import sort
from re import nil
from strUtils import endsWith, parseInt, split
import tables
from times import nil

proc step1() =
  var rows: seq[string]
  for row in lines("day4input.txt"):
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


when isMainModule:
  var time = times.cpuTime()
  step1()
  echo "Steps 1 and 2 took: ", (times.cpuTime() - time) * 1000, " ms"
