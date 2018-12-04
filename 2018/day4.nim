from algorithm import sort
from re import nil
from strUtils import endsWith, parseInt, split
import tables
from times import nil

const TEST_DATA = [
  "[1518-11-01 00:00] Guard #10 begins shift",
  "[1518-11-01 00:05] falls asleep",
  "[1518-11-01 00:25] wakes up",
  "[1518-11-01 00:30] falls asleep",
  "[1518-11-01 00:55] wakes up",
  "[1518-11-01 23:58] Guard #99 begins shift",
  "[1518-11-02 00:40] falls asleep",
  "[1518-11-02 00:50] wakes up",
  "[1518-11-03 00:05] Guard #10 begins shift",
  "[1518-11-03 00:24] falls asleep",
  "[1518-11-03 00:29] wakes up",
  "[1518-11-04 00:02] Guard #99 begins shift",
  "[1518-11-04 00:36] falls asleep",
  "[1518-11-04 00:46] wakes up",
  "[1518-11-05 00:03] Guard #99 begins shift",
  "[1518-11-05 00:45] falls asleep",
  "[1518-11-05 00:55] wakes up"
]

proc step1(): int =
  var rows: seq[string]
  for row in lines("day4input.txt"):
    rows.add(row)
  sort(rows, cmp)

  var minutes_asleep_per_guard = newCountTable[string]()
  var sleepiest_mins = initTable[string, array[60, int]]()
  var sleeping_since = times.now()
  var current_guard: string

  for row in rows:
    var matches: array[2, string]
    discard re.match(row, re.re"\[([\d\s:-]+)\] (.+)$", matches)
    let date = times.parse(matches[0], "yyyy-MM-dd HH:mm")

    if matches[1].endsWith("begins shift"):
      current_guard = split(matches[1])[1]
    elif matches[1].endsWith("falls asleep"):
      sleeping_since = date
    else: # Woke up
      let slept_minutes = times.between(sleeping_since, date).minutes
      echo "Guard ", current_guard, " slept for ", slept_minutes

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
  echo "Most asleep: ", most_asleep[0], " for ", most_asleep[1], " mins"

  var sleepiest_minute = 0
  for i, mins_asleep in sleepiest_mins[most_asleep[0]]:
    if mins_asleep > sleepiest_mins[most_asleep[0]][sleepiest_minute]:
      sleepiest_minute = i

  echo "Sleepiest minute: ", sleepiest_minute

  # Step 2:
  var
    max_frequent_guard_id = most_asleep[0]
    max_frequent_minute = 0
  for guard_id, sleep_minutes in sleepiest_mins:
    for i, m in sleep_minutes:
      if m > sleepiest_mins[max_frequent_guard_id][max_frequent_minute]:
        max_frequent_guard_id = guard_id
        max_frequent_minute = i

  echo "Most frequent guard: ", max_frequent_guard_id, ", minute: ", max_frequent_minute
  return 0


when isMainModule:
  var time = times.cpuTime()
  echo "Step 1: ", step1(), " took ", (times.cpuTime() - time) * 1000, " ms"
