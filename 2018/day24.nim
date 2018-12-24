import algorithm, sequtils, strformat, strscans, strutils
from times import epochTime


type
  AttackType = enum radiation, fire, slashing, cold, bludgeoning
  Group = tuple[key, units, hp, damage, initiative, team: int, attack_type: AttackType, immune, weak: set[AttackType]]

const ATTACK_TYPES = ["radiation", "fire", "slashing", "cold", "bludgeoning"]

proc read_input(): seq[Group] =
  var
    team = 0
    key = 0
  for line in lines("inputs/day24.txt"):
    if line == "Immune System:" or line == "":
      continue
    if line == "Infection:":
      team = 1
      continue

    var units, hp, damage, initiative: int
    var attack_type: AttackType
    var immune, weak: set[AttackType]
    var p1 = line.split(" hit points ")
    discard scanf(p1[0], "$i units each with $i", units, hp)

    var p2 = p1[1].split("with an attack that does ")
    if len(p2) == 2:
      let immune_weak = p2[0].split({ ';' })
      for i, att in ATTACK_TYPES:
        if att in p2[1]:
          attack_type = AttackType(i)
        for g in immune_weak:
          if "immune to " in g and att in g:
            immune.incl(AttackType(i))
          if "weak to " in g and att in g:
            weak.incl(AttackType(i))

      discard scanf(p2[1], "$i", damage)
      discard scanf(p2[1].split()[^1], "$i", initiative)
    else:
      for i, att in ATTACK_TYPES:
        if att in p2[0]:
          attack_type = AttackType(i)
          break
      discard scanf(p2[0], "$i", damage)
      discard scanf(p2[0].split()[^1], "$i", initiative)
    let group: Group = (key, units, hp, damage, initiative, team, attack_type, immune, weak)
    result.add(group)
    key.inc()


proc step1(): int =
  var groups = read_input()
  var targets: seq[int]
  for g in groups:
    targets.add(-1)

  var
    boost = 46
    i = 0

  for g in groups.mitems:
    if g.team == 0:
      g.damage += boost

  while true:
    for i, t in targets:
      targets[i] = -1

    # 1. select targets:
    groups = groups.sortedByIt((it.units * it.damage, it.initiative))
    groups.reverse()

    for i, attacker in groups:
      if attacker.units <= 0:
        continue

      var max_damage = 0
      for j, defender in groups:
        if attacker.team == defender.team or j in targets or attacker.attack_type in defender.immune or defender.units <= 0:
          continue
        var damage = attacker.damage * attacker.units
        if attacker.attack_type in defender.weak:
          damage *= 2
        if damage > max_damage:
          max_damage = damage
          targets[attacker.key] = j


    # 2. deal attacks:
    for a in groups.sortedByIt(it.initiative).reversed():
      let attacker = groups.filterIt(it.key == a.key)[0]
      if attacker.units <= 0 or targets[attacker.key] == -1:
        continue

      let defender = groups[targets[attacker.key]]
      var damage = attacker.units * attacker.damage
      if attacker.attack_type in defender.weak:
        damage *= 2

      let units_killed = damage div defender.hp
      groups[targets[attacker.key]].units -= units_killed

    var t0_left, t1_left: int
    for g in groups:
      if g.team == 0 and g.units > 0:
        t0_left += g.units
      elif g.team == 1 and g.units > 0:
        t1_left += g.units
    if t0_left == 0:
      # return t1_left                  <-- step 1
      break            #                <-- step 2
    if t1_left == 0:
      return t0_left

    i.inc()

when isMainModule:
  var t0 = epochTime()
  echo &"Step 1: {step1()}, took {(epochTime() - t0) * 1000:3} ms"
