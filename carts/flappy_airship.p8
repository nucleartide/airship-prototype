pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- https://itch.io/jam/retro-platformer-jam

--[[

  todo:

    ## nice-to-haves

    - [ ] parallax scrolling
    - [ ] curried text functions
    - [ ] enemies, since you are passing in `btn`
    - [ ] mass-based physics
    - [ ] inertia, guy on twitter had this as a field
    - [ ] animation type
    - [ ] particle system

    ## todo right now:

    - [x] revisit player
    - [x] revisit airship
    - [x] revisit bounds - everything should be centered
    - [x] define colliders
    - [ ] resolve collisions for all colliders

    ## low priority

    - [ ] visual representation for colliders
      - [ ] draw one collider at a time

]]

--
-- game loop.
--

do
  local g

  function _init()
    g = game()
  end

  function _update60()
    g = game_update(g)
  end

  function _draw()
    game_draw(g)
  end
end

--
-- game entity.
--

-- game :: game
function game()
  return {
    airship = airship(),
    player  = player(),
  }
end

-- game_update :: game -> game
function game_update(g)
  g.airship = airship_update(g.airship)
  g.player = player_update(btn, g.player)
  g.player = player_resolve_collision(g.player, g.airship)
  return g
end

-- game_draw :: game -> io ()
function game_draw(g)
  cls(13)
  airship_draw(g.airship)
  player_draw(g.player)
  -- print(stat(1))
end

--
-- player entity.
--

-- player :: player
-- note: player origin is at top left.
function player()
  return {
    pos       = vec2(40, -10),
    vel       = vec2(),
    acc       = vec2(0, 0.15),
    move_vel  = 0.05,
    move_lerp = 0.8,
    max_vel   = vec2(1, 2.5),
    min_vel   = vec2(-1, -2),
    w         = 3,
    h         = 4,
  }
end

-- player_update :: btn_state -> player -> player
function player_update(btn_state, p)
  p.acc.x =
    btn_state(0) and -p.move_vel or
    btn_state(1) and p.move_vel  or
    0

  -- update x-component of velocity
  if btn_state(0) or btn_state(1) then
    p.vel.x += p.acc.x
  else
    p.vel.x = lerp(p.vel.x, 0, p.move_lerp)
  end

  -- update y-component of velocity
  p.vel.y += p.acc.y

  -- clamp velocity
  vec2_clamp_between(p.vel, p.min_vel, p.max_vel)

  -- update position
  vec2_add_to(p.vel, p.pos)

  return p
end

-- player_draw :: player -> io ()
function player_draw(p)
  rectfill(p.pos.x, p.pos.y, p.pos.x+p.w-1, p.pos.y+p.h-1, 8)
  pset(p.pos.x, p.pos.y, 7)
  pset(p.pos.x+p.w-1, p.pos.y+p.h-1, 7)
end

--[[
data bound =
  bound
    { top_left     :: vec2
    , bottom_right :: vec2
    }
]]

-- player_bound :: player -> bound
function player_bound(p)
  return {
    top_left     = vec2(p.pos.x,       p.pos.y),
    bottom_right = vec2(p.pos.x+p.w-1, p.pos.y+p.h-1),
  }
end

-- todo: resolves colliders twice

-- player_resolve_collision :: player -> airship -> player
function player_resolve_collision(p, airship)

  for i=1,#airship.colliders do
    local p_bounds = player_bound(p)
    -- iteration var...
    local collider = airship.colliders[i]

    -- convert to world space
    local new_collider = {
      top_left     = airship_to_world_space(airship, collider.top_left),
      bottom_right = airship_to_world_space(airship, collider.bottom_right),
    }

    -- is the player colliding with this collider?
    local is_colliding, penetration_vec = collides(p_bounds, new_collider)

    -- if so, resolve collision
    if is_colliding then
      p.pos   = vec2_sub_from(penetration_vec, p.pos)
      --p.vel.y = 0
    end
  end

  return p
end

--
-- vec2 util.
--

-- vec2 :: float -> float -> vec2
function vec2(x, y)
  return {
    x = x or 0,
    y = y or 0,
  }
end

-- vec2_print :: vec2 :: io ()
function vec2_print(v)
  print(v.x .. ', ' .. v.y)
end

-- vec2_add_to :: vec2 -> vec2 -> vec2
function vec2_add_to(a, b)
  local ax, ay = a.x, a.y
  local bx, by = b.x, b.y
  b.x = ax + bx
  b.y = ay + by
  return b
end

-- vec2_sub_from :: vec2 -> vec2 -> vec2
-- note: b is first arg.
function vec2_sub_from(b, a)
  local ax, ay = a.x, a.y
  local bx, by = b.x, b.y
  a.x = ax - bx
  a.y = ay - by
  return a
end

-- vec2_mul_by :: vec2 -> float -> vec2
function vec2_scale_by(v, s)
  v.x *= s
  v.y *= s
  return v
end

-- vec2_clamp :: vec2 -> vec2 -> vec2 -> vec2
function vec2_clamp_between(v, lower, upper)
  local lx, ly = lower.x, lower.y
  local vx, vy = v.x, v.y
  local ux, uy = upper.x, upper.y
  v.x = clamp(lx, vx, ux)
  v.y = clamp(ly, vy, uy)
end

--
-- airship entity.
--

-- airship :: airship
function airship()
  local colliders = {
    -- middle platform
    {
      top_left     = vec2(-2, 0),
      bottom_right = vec2(2, 1),
    },

    -- ceiling
    {
      top_left     = vec2(-4, -4),
      bottom_right = vec2(4, -3),
    },

    -- floor
    {
      top_left     = vec2(-4, 3),
      bottom_right = vec2(4, 4),
    },

    -- left wall
    {
      top_left     = vec2(-5, -3),
      bottom_right = vec2(-4, 3),
    },

    -- right wall
    {
      top_left     = vec2(4, -3),
      bottom_right = vec2(5, 3),
    },

    -- bottom left corner
    {
      top_left     = vec2(-5, 2),
      bottom_right = vec2(-2, 3),
    },

    -- bottom right corner
    {
      top_left     = vec2(2, 2),
      bottom_right = vec2(5, 3),
    },
  }

  for i=1,#colliders do
    vec2_scale_by(colliders[i].top_left,     5)
    vec2_scale_by(colliders[i].bottom_right, 5)
  end

  return {
    pos       = vec2(40, 50),
    vel       = vec2(),
    acc       = vec2(0, .01),
    max_vel   = vec2(2, .25),
    min_vel   = vec2(-2, -2),
    colliders = colliders,
  }
end

-- airship_to_world_space :: airship -> vec2 -> vec2
function airship_to_world_space(a, v)
  local new_vec = vec2()
  vec2_add_to(a.pos, new_vec)
  vec2_add_to(v,     new_vec)
  return new_vec
end

-- airship_update :: airship -> airship
function airship_update(a)
  vec2_add_to(a.acc, a.vel)
  vec2_clamp_between(a.vel, a.min_vel, a.max_vel)
  vec2_add_to(a.vel, a.pos)
  return a
end

-- airship_draw :: airship -> io ()
function airship_draw(a)
  for i=1,#a.colliders do
    local wall = a.colliders[i]

    local v1 = vec2()
    local v2 = vec2()

    vec2_add_to(wall.top_left, v1)
    -- vec2_scale_by(v1, 5)
    vec2_add_to(a.pos, v1)

    vec2_add_to(wall.bottom_right, v2)
    -- vec2_scale_by(v2, 5)
    vec2_add_to(a.pos, v2)

    rectfill(
      v1.x,
      v1.y,
      v2.x,
      v2.y,
      12
    )

    pset(v1.x, v1.y, 9)
    pset(v2.x, v2.y, 9)
  end
end

--
-- math utils.
--

-- lerp :: float -> float -> float -> float
function lerp(a, b, t)
  return (1-t)*a + t*b
end

-- clamp :: float -> float -> float -> float
function clamp(lower, n, upper)
  return min(max(lower, n), upper)
end

-- minkowski_difference :: bound -> bound -> bound
function minkowski_difference(a, b)
  local top    = a.top_left.y     - b.bottom_right.y-1
  local bottom = a.bottom_right.y - b.top_left.y+1
  local left   = a.top_left.x     - b.bottom_right.x-1
  local right  = a.bottom_right.x - b.top_left.x+1

  return {
    top_left     = vec2(left,  top),
    bottom_right = vec2(right, bottom),
  }, top, bottom, left, right
end

-- collides :: bound -> bound -> (bool, bound, vec2)
function collides(bound0, bound1)
  local diff, t, b, l, r = minkowski_difference(bound0, bound1)

  -- if the minkowski difference intersects the origin,
  -- then a and b collide.
  local is_colliding = true
    and diff.top_left.x < 0
    and diff.bottom_right.x > 0
    and diff.top_left.y < 0
    and diff.bottom_right.y > 0

  -- resolve vertical collision first
  penetration_vec.x = 0
  penetration_vec.y = t
  local current_min = abs(t)

  if abs(b) < current_min then
    current_min = abs(b)
    penetration_vec.x = 0
    penetration_vec.y = b
  end

  if abs(l) < current_min then
    current_min = abs(l)
    penetration_vec.x = l
    penetration_vec.y = 0
  end

  if abs(r) < current_min then
    current_min = abs(r)
    penetration_vec.x = r
    penetration_vec.y = 0
  end

  return is_colliding, diff
end
__gfx__
00000000eeeeeeee0000eeeeeeeeeeeeeeeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000eeeeeeee000e000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700eeeeeeee00e00000000000000000000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000eeeeeeee0e00000eeeeeeeeeeeee0000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000eeeeeeeee000000eeeeeeeeeeeee00000000e00007000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700eeeeeeeee000000eeeeeeeeeeeee00000000e00077700000000000000000000000000000000000000000000000000000000000000000000000000000
00000000eeeeeeeee000000000000000000000000000e00007000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000eeeeeeeee000000000000000000000000000e00070700000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000e000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000e000000000000000000000eeeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000e000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000e000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000e0000eeeeeee000eee0000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000e0000eeeeeee000eee0000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000e000000000000000000000ee0000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000e000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000e0000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000e000000000eeeeee00000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000e00000000eeeeee0000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000eeeeeeeeeeeeeeeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010100000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000101010000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000001010101010001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
