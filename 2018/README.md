# Advent of Code 2018

My solutions for [2018](https://adventofcode.com/2018/). Trying to pick up [Nim](https://nim-lang.org/) in the process.

| Day | Notes |
|---|-------|
| 1 | Getting started. `defer` seems neat. Having a `sets` module on top of the built-in `set` type seems a bit cumbersome.  |
| 2 | Learned about `tables`. |
| 3 | Used regex for parsing; discovered later that `scanf` would've made a better fit. |
| 4 | Tried to copy the Nim implementation into Python; Nim compiled with `-d:release` runs ~3x faster. Plenty of room for optimization I'm sure. |
| 5 | Using `seq[char]` instead of building a `string` really sped things up. Learned a neat `xor` trick from [narimiran](https://github.com/narimiran/AdventOfCode2018/blob/master/nim/day05.nim#L9) after submitting the first version. |
| 6 | Struggled with this one! Learned about convex hull algorithms which was interesting, though I assume a fast solution doesn't resort to stuff like that. Tried `nimprof` for profiling too. |
| 7 | Again a tricky one, they're definitely getting harder. Found out about the `sugar` module, which implements ES6-esque arrow functions as macros, cool! Type inference works impressively with them too. Diving into the standard modules as well with `sequtils`, `strscans` and `strformat`. After submitting I learned about `heapqueue` (priority queue module) from [narimiran](https://github.com/narimiran/AdventOfCode2018) again: that sped things up ~2x. |
| 8 | This one was a breeze, reversing the input and popping items recursively. Shaved off a few milliseconds by streaming input with `newFileStream`. |
| 9 | Used `seq` first but step 2 took ages because of the slow `insert` operation.Replaced `seq` with `DoublyLinkedRing` from `lists` module, which makes step 2 finish in about half a second. |
| 10 | Relatively straightforward approach: simulated the velocities until distance between points starts to grow. Chaining `sequtils` functions can result in pretty functional code. |
| 11 | Slow naive solution for step 2 for now. |
| 12 | Optimized part 1 by casting `array[bool]` into `int8` and doing bit shifting. Part 2 was really tricky! |
| 13 | The code is basically just a big conditional in a loop. Missed pattern matching here, ought to try one of the macro based pattern matching libraries. |
| 14 | Tried `DoublyLinkedList` and a separate queue for keeping track of recipes tail for step 2, since it ran for too long. That was all in vain though: what did the trick was avoiding full cycles over the recipes list!  |
| 15 | Trickiest one so far. Implementing breadth-first search in a way that the task-specified reading order applied took a while. The code is a mess! |
| 16 | A fun one. Solved part 2's mapping from opcode to instruction on paper. Couldn't find a way to retrieve a functions name in runtime, wonder if that's doable? Getting the size of a set with `.card()` (as in cardinality) instead of `.len()` was a bit confusing. |
| 17 | Took some debugging, this one. Cool to visualize! |
| 18 | Step 1 was one of the easiest so far. Step 2 in turn was basically incomputable, so had to resort to scanning output and figuring out a pattern. Tried to optimize step 2 first by inlining everything and following other tricks from https://chameth.com/2018/12/09/over-the-top-optimisations-in-nim/. |
| 19 | More assembler instructions akin to day 16. Step 2 same as above, pattern analysis. |
| 20 | Regex parsing. Took a while to get the nested/recursive cases working. Pattern matching would've been handy again! |
| 21 | Continuing with assembler instructions as per day 16 and 19. Not much of coding involved in this one, just trying to decompile the instructions. |
