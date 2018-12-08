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
| 7 | Again a tricky one, they're definitely getting harder. Found out about the `future` module, which implements ES6-esque arrow functions as macros, cool! Type inference works impressively with them too. Diving into the standard modules as well with `sequtils`, `strscans` and `strformat`. After submitting I learned about `heapqueue` (priority queue module) from [narimiran](https://github.com/narimiran/AdventOfCode2018) again: that sped things up ~2x. |
| 8 | This one was a breeze, reversing the input and popping items recursively. Shaved off a few milliseconds by streaming input with `newFileStream`. |
