import strscans, strutils

let input = """<x=-4, y=-14, z=8>
<x=1, y=-8, z=10>
<x=-15, y=2, z=1>
<x=-17, y=-17, z=16>"""

type
  Vec3 = tuple[x, y, z: int]
  Moon = tuple[pos, vel: Vec3]
  Moons = array[4, Moon]

proc read_input(): Moons =
  for i, line in input.splitLines().pairs():
    var x, y, z: int
    assert scanf(line, "<x=$i, y=$i, z=$i>", x, y, z) == true
    result[i] = (pos: (x, y, z), vel: (0, 0, 0))

func total_energy(moons: Moons): int =
  for m in moons:
    let
      potential_energy = abs(m.pos.x) + abs(m.pos.y) + abs(m.pos.z)
      kinetic_energy = abs(m.vel.x) + abs(m.vel.y) + abs(m.vel.z)
    result += potential_energy * kinetic_energy

proc step1(): int =
  var
    moons = read_input()
    steps = 0

  while steps < 1000:
    # Apply gravity:
    for i, m1 in moons.mpairs:
      for j, m2 in moons.mpairs:
        if j <= i:
          continue

        if m1.pos.x > m2.pos.x:
          m1.vel.x -= 1
          m2.vel.x += 1
        elif m1.pos.x < m2.pos.x:
          m1.vel.x += 1
          m2.vel.x -= 1

        if m1.pos.y > m2.pos.y:
          m1.vel.y -= 1
          m2.vel.y += 1
        elif m1.pos.y < m2.pos.y:
          m1.vel.y += 1
          m2.vel.y -= 1

        if m1.pos.z > m2.pos.z:
          m1.vel.z -= 1
          m2.vel.z += 1
        elif m1.pos.z < m2.pos.z:
          m1.vel.z += 1
          m2.vel.z -= 1

    # Apply velocity:
    for m in moons.mitems:
      m.pos.x += m.vel.x
      m.pos.y += m.vel.y
      m.pos.z += m.vel.z

    steps += 1

  echo "After ", steps, " steps:"
  for m in moons:
    echo m

  return total_energy(moons)

proc step2(): int =
  var
    moons = read_input()
    steps = 0
  let initial_state = moons

  while true:
    # Apply gravity:
    for i, m1 in moons.mpairs:
      for j, m2 in moons.mpairs:
        if j <= i:
          continue

        if m1.pos.x > m2.pos.x:
          m1.vel.x -= 1
          m2.vel.x += 1
        elif m1.pos.x < m2.pos.x:
          m1.vel.x += 1
          m2.vel.x -= 1

        # if m1.pos.y > m2.pos.y:
        #   m1.vel.y -= 1
        #   m2.vel.y += 1
        # elif m1.pos.y < m2.pos.y:
        #   m1.vel.y += 1
        #   m2.vel.y -= 1

        # if m1.pos.z > m2.pos.z:
        #   m1.vel.z -= 1
        #   m2.vel.z += 1
        # elif m1.pos.z < m2.pos.z:
        #   m1.vel.z += 1
        #   m2.vel.z -= 1

    # Apply velocity:
    for m in moons.mitems:
      m.pos.x += m.vel.x
      # m.pos.y += m.vel.y
      # m.pos.z += m.vel.z

    steps += 1

    if moons == initial_state:
      break

  return steps


when isMainModule:
  echo "Step 1: ", step1()
  echo "Step 2: ", step2()
