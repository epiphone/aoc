from collections import defaultdict
import datetime
import time

def steps_1_and_2_b():
    rows = []
    with open("day4input.txt", "r") as input_f:
        rows = input_f.readlines()
    rows.sort()

    guards = defaultdict(lambda: 60 * [0]) # TODO try with dict instead of list
    current_guard = None
    sleeping_since = None

    for row in rows:
        parts = row.split()
        date_str = (parts[0] + parts[1])[1:-1]
        date = datetime.datetime.strptime(date_str, '%Y-%m-%d%H:%M')

        if parts[-1] == 'shift':
            # New guard started a shift:
            current_guard = int(parts[3][1:])
        elif parts[-1] == "asleep":
            # Guard fell asleep:
            sleeping_since = date
        else:
            # Guard woke up:
            if sleeping_since.minute > date.minute:
                for m in range(sleeping_since.minute, 60):
                    guards[current_guard][m] += 1
                for m in range(date.minute):
                    guards[current_guard][m] += 1
            else:
                for m in range(sleeping_since.minute, date.minute):
                    guards[current_guard][m] += 1

    top_sleeper = None
    max_sleeper_mins = 0
    top_frequency_sleeper = None
    max_freq_min = 0
    max_freq_mins_slept = 0

    for guard, minutes in guards.items():
        sleeper_mins = sum(minutes)
        if sleeper_mins > max_sleeper_mins:
            top_sleeper = guard
            max_sleeper_mins = sleeper_mins
        for i, m in enumerate(minutes):
            if m > max_freq_mins_slept:
                max_freq_mins_slept = m
                max_freq_min = i
                top_frequency_sleeper = guard

    print("The sleepiest guard", top_sleeper, "slept in total for", max_sleeper_mins, "mins")
    print("Most frequent minute was for guard", top_frequency_sleeper, ", minute", max_freq_min)


if __name__ == "__main__":
    t = time.time()
    steps_1_and_2_b()
    print("Steps 1 and 2 took:", round((time.time() - t) * 1000, 2), "ms")
