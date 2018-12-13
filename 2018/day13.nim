import algorithm
import sequtils
import strformat
import sugar
from times import epochTime


type Point = tuple[x, y: int]
type Direction = enum left, straight, right
type Cart = tuple[pos: Point, vel: Point, prev_dir: Direction]

func next_direction(direction: Direction): Direction =
  case direction
  of left:
    straight
  of straight:
    right
  of right:
    left

# proc read_input(): (array[7, array[7, char]], seq[Cart]) =
proc read_input(): (array[150, array[150, char]], seq[Cart]) =
  var y = 0
  for line in lines("inputs/day13.txt"):
  # for line in lines("inputs/day13-test.txt"):
    for x, c in line:
      if c == '<':
        result[0][y][x] = '-'
        result[1].add(((x, y), (-1, 0), right))
      elif c == '>':
        result[0][y][x] = '-'
        result[1].add(((x, y), (1, 0), right))
      elif c == '^':
        result[0][y][x] = '|'
        result[1].add(((x, y), (0, -1), right))
      elif c == 'v':
        result[0][y][x] = '|'
        result[1].add(((x, y), (0, 1), right))
      else:
        result[0][y][x] = c
    y.inc()


proc step1(): Point =
  var (tracks, carts) = read_input()

  proc print_track() =
    for y, row in tracks:
      var row_str = newStringOfCap(row.len)
      for x, c in row:
        if any(carts, (c) => c.pos == (x, y)):
          row_str.add('X')
        else:
          row_str.add(c)
      echo row_str

  # print_track()

  var i = 0
  # while i < 10:
  while carts.len > 1:
    # echo i
    # print_track()
    i.inc()
    carts = carts.sortedByIt((it.pos.y, it.pos.x))
    var collided: set[int8]

    for cart_i, cart in carts.mpairs:
      let (pos, vel, prev_dir) = cart
      let track = tracks[pos.y][pos.x]
      if cast[int8](cart_i) in collided:
        continue

      case track
      of '/':
        if vel.x == 1:
          cart.vel = (0, -1)
          cart.pos = (pos.x, pos.y - 1)
        elif vel.x == -1:
          cart.vel = (0, 1)
          cart.pos = (pos.x, pos.y + 1)
        elif vel.y == 1:
          cart.vel = (-1, 0)
          cart.pos = (pos.x - 1, pos.y)
        else:
          cart.vel = (1, 0)
          cart.pos = (pos.x + 1, pos.y)
      of '\\':
        if vel.x == 1:
          cart.vel = (0, 1)
          cart.pos = (pos.x, pos.y + 1)
        elif vel.x == -1:
          cart.vel = (0, -1)
          cart.pos = (pos.x, pos.y - 1)
        elif vel.y == 1:
          cart.vel = (1, 0)
          cart.pos = (pos.x + 1, pos.y)
        else:
          cart.vel = (-1, 0)
          cart.pos = (pos.x - 1, pos.y)
      of '-', '|':
        cart.vel = vel
        cart.pos = (pos.x + vel.x, pos.y + vel.y)
      of '+':
        let new_dir = next_direction(prev_dir)
        case new_dir
        of left:
          if vel.x == 0:
            cart.vel = (vel.y, 0)
            cart.pos = (pos.x + cart.vel.x, pos.y)
          else:
            cart.vel = (0, -vel.x)
            cart.pos = (pos.x, pos.y + cart.vel.y)
          cart.prev_dir = new_dir
        of straight:
          cart.vel = vel
          cart.pos = (pos.x + vel.x, pos.y + vel.y)
          cart.prev_dir = new_dir
        of right:
          if vel.x == 0:
            cart.vel = (-vel.y, 0)
            cart.pos = (pos.x + cart.vel.x, pos.y)
          else:
            cart.vel = (0, vel.x)
            cart.pos = (pos.x, pos.y + cart.vel.y)
          cart.prev_dir = new_dir
      else:
        assert false, "missing handling for case of track=" & track

      for k, c in carts:
        if cart_i != k and cart.pos == c.pos:
          echo &"Collision in generation {i} at {cart.pos}!"
          collided.incl(cast[int8](cart_i))
          collided.incl(cast[int8](k))

    var new_carts: seq[Cart] = @[]
    for i, c in carts:
      if not (cast[int8](i) in collided):
        new_carts.add(c)

    carts = new_carts
    if carts.len() == 1:
      echo carts



when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3}ms"
