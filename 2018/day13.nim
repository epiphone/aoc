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

proc read_input(): (array[150, array[150, char]], seq[Cart]) =
  var y = 0
  for line in lines("inputs/day13.txt"):
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

proc step_cart(cart: var Cart, current_track: char) =
  let (pos,vel, prev_dir) = cart
  if current_track in {'/', '\\'}:
    let multiplier = if current_track == '/': 1 else: -1
    if vel.x == 1:
      cart.vel = (0, -1 * multiplier)
    elif vel.x == -1:
      cart.vel = (0, 1 * multiplier)
    elif vel.y == 1:
      cart.vel = (-1 * multiplier, 0)
    else:
      cart.vel = (1 * multiplier, 0)
  elif current_track == '+':
    let new_dir = next_direction(prev_dir)
    if new_dir in {left, right}:
      let multiplier = if new_dir == left: 1 else: -1
      if vel.x == 0:
        cart.vel = (vel.y * multiplier, 0)
      else:
        cart.vel = (0, -vel.x * multiplier)
    cart.prev_dir = new_dir

  cart.pos = (pos.x + cart.vel.x, pos.y + cart.vel.y)

proc step1_and_2(): Point =
  var (tracks, carts) = read_input()

  while carts.len > 1:
    carts = carts.sortedByIt((it.pos.y, it.pos.x))
    var collided: set[int8]

    for cart_i, cart in carts.mpairs:
      let (pos, vel, prev_dir) = cart
      let track = tracks[pos.y][pos.x]
      if cast[int8](cart_i) in collided:
        continue

      step_cart(cart, track)

      for k, c in carts:
        if cart_i != k and cart.pos == c.pos:
          echo &"Collision in generation at {cart.pos}!"
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
  echo &"Steps 1 and 2: {step1_and_2()}, took {(epochTime() - t0) * 1000:3}ms"
