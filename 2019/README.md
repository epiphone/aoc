# Advent of Code 2019

My solutions for [2019](https://adventofcode.com/2019/). Back at it with [Nim](https://nim-lang.org/)!

The code isn't polished at all, mind you. I'm usually going for the leaderboard, not the optimal or most elegant solution.

| Day | Notes |
|---|-------|
| 1 | A good easy start. Relearning all the Nim syntax I forgot since last year's AoC... |
| 2 | Brute-forced part 2. Could've probably reused some of the instruction pointer code from last year. |
| 3 | Submitted a non-imaginative solution of just iterating through each point in rope paths, later optimized with a hash table. |
| 4 | Apparently if you keep refreshing the page seconds before a task is released they redirect you to an old task... anyway I did solve day 4 from **2015** pretty fast! Lesson learned. Eventually I did get to this year's task as well: nothing particularly smart there, just iterating through the whole range and checking for the conditions. |
| 5 | Picking off from day 2 with the CPU instruction stuff. Pretty happy to make it to the leaderboard with step 2 at #92. |
| 6 | Rolled out Dijkstra's algorithm in step 2. |
| 7 | More CPU instructions. Got fed up with step 2, might return to it later. |
| 8 | Tried to use fixed-size arrays instead of dynamic tables or sequences wherever possible. |
| 9 | The instructions caused some head-scratching since at first I didn't realize the new relative mode also applies to memory writes. In the end I rewrote the whole computer step by step which solved the bug. |
| 10 | Totally different approaches for steps 1 and 2. The latter part caused a headache before I got around to sorting the asteroids by angle and distance from the base station. |
| 11 | Yet another CPU instruction task. Missing Python's list comprehensions and `defaultdict`. |
| 12 | Finished step 2 by running the simulation separately per axis and then calculating their least common denominator. |
| 13 | Ol' intcode computer at it again. This one was a blast! |
| 14 | Step 1 really tripped me up. Learned of `tables.mgetOrPut`, a good counterpart for Python's `defaultdict`. |
| 15 | Took a lot of work, this one. Fun to render step-by-step though! |
| 16 | Had fun optimizing step 1 from a `sequtils`-based solution to something more sensible with fewer intermediate objects. Step 2 was purely based on finding a pattern between phases. |
| 17 | Learned that I can't mutate a table `mem[0] = 2` without importing `tables`, interesting. |
| 20 | Parsing input was pretty tricky this time. Went with breadth-first search and added a 3rd dimension for step 2. |
