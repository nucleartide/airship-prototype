pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
printh('')
printh('game start!')

--
-- config.
--

config = {
  grav = 10, -- newtons
}

--
-- init state machine.
--

function fsm(s)
  assert(s ~= nil, 'must init fsm.')
  local c, i = s, s.init()
  local function t(n) c, i = n, n.init() end
  function _update60() c.update(i, t) end
  function _draw() c.draw(i) end
end

function _init()
  fsm(game)
end

--
-- game state.
--

game = {}

function game.init()
  return {
    player  = player(),
    airship = airship(),
  }
end

function game.update(g)
  airship_update(g.airship)
  player_update(btn, g.player)
  player_resolve_collision(g.player, g.airship)
end

function game.draw(g)
  cls(0)
  circfill(64, 64, 50, 1)
  airship_draw(g.airship)
  player_draw(g.player)
end

--
-- vec2 util.
--

function vec2(x, y)
  return {
    x = x or 0,
    y = y or 0,
  }
end

function vec2_print(v)
  print(v.x .. ', ' .. v.y)
end

function vec2_printh(v)
  printh(v.x .. ', ' .. v.y)
end

function vec2_add_to(a, b)
  local ax, ay = a.x, a.y
  local bx, by = b.x, b.y
  b.x = ax + bx
  b.y = ay + by
end

function vec2_sub_from(b, a)
  local ax, ay = a.x, a.y
  local bx, by = b.x, b.y
  a.x = ax - bx
  a.y = ay - by
end

function vec2_scale_by(v, s)
  v.x *= s
  v.y *= s
end

function vec2_zero(v)
  v.x = 0
  v.y = 0
end

-- vec2_clamp :: vec2 -> vec2 -> vec2 -> void
function vec2_clamp_between(v, lower, upper)
  local lx, ly = lower.x, lower.y
  local vx, vy = v.x, v.y
  local ux, uy = upper.x, upper.y
  v.x = clamp(lx, vx, ux)
  v.y = clamp(ly, vy, uy)
end

-- vec2_clamp_by :: vec2 -> vec2 -> void
function vec2_clamp_by(v1, v2)
  local v1x, v1y = v1.x, v1.y
  local v2x, v2y = v2.x, v2.y
  v1.x = clamp(-v2.x, v1.x, v2.x)
  v1.y = clamp(-v2.y, v1.y, v2.y)
end

--
-- player entity.
--

local player_state = {
  normal    = 0,
  move_ship = 1,
}

function player()
  local mass = 80

  return {
    pos           = vec2(64, 60),
    vel           = vec2(),
    acc           = vec2(0, config.grav / mass),
    move_vel      = 0.05,
    move_lerp     = 0.8,
    move_lerp_air = 1,
    w             = 2,
    h             = 2,
    m             = mass,
    max_vel       = vec2(0.5, 2.5),
    is_grounded   = false,
    jump_vel      = -.75,

    -- note: don't use this,
    -- use `player_bounds()` so values get updated.
    bounds = {
      top_left     = vec2(),
      bottom_right = vec2(),
    },

    player_state = player_state.move_ship,

    -- stored as angle
    propeller = 0.25,
    desired_propel_angle = 0.25,
  }
end

-- player_update :: btn_state -> player -> player
function player_update(btn_state, p)

  --
  -- update x-component of velocity.
  --

  p.acc.x =
    btn_state(0) and -p.move_vel or
    btn_state(1) and p.move_vel  or
    0

  -- overwrite depending on state.
  if p.player_state ~= player_state.normal then
    p.acc.x = 0
  end

  if p.acc.x ~= 0 then
    -- the line below adds sliding when abruptly changing dir.
    p.vel.x += p.acc.x
  elseif p.is_grounded then
    -- decelerate when grounded.
    p.vel.x = lerp(p.vel.x, 0, p.move_lerp)
  else
    -- decelerate when in-air.
    p.vel.x = lerp(p.vel.x, 0, p.move_lerp_air)
  end

  --
  -- update y-component of velocity.
  --

  p.vel.y += p.acc.y

  if p.is_grounded and btn(5) then -- x button
    -- jump.
    p.vel.y = p.jump_vel
  end

  --
  -- clamp velocity, update position.
  --

  vec2_clamp_by(p.vel, p.max_vel)
  vec2_add_to(p.vel, p.pos)

  --
  -- if in move ship state, update propeller angle
  --
  -- shouldn't be tied to the player's position...
  --

  local desired_x, desired_y = 0, 0
  if p.player_state == player_state.move_ship then

    if btn(0) and not btn(1) then
      desired_x = -1
    elseif not btn(0) and btn(1) then
      desired_x = 1
    end

    if btn(2) and not btn(3) then
      desired_y = -1
    elseif not btn(2) and btn(3) then
      desired_y = 1
    end

    if desired_x == 0 and desired_y == 0 then
      p.desired_propel_angle = p.propeller
    else
      p.desired_propel_angle = atan2(desired_x, desired_y)
    end
  end

  --
  -- update p.propeller angle.
  --

  if desired_x ~= 0 or desired_y ~= 0 then
    local negate = p.desired_propel_angle - 1
    local positive = p.desired_propel_angle + 1

    if abs(negate - p.propeller) < abs(p.desired_propel_angle - p.propeller) then
      p.propeller = lerp(p.propeller, negate, 0.1)
      p.propeller = p.propeller % 1
    elseif abs(positive - p.propeller) < abs(p.desired_propel_angle - p.propeller) then
      p.propeller = lerp(p.propeller, positive, 0.1)
      p.propeller = p.propeller % 1
    else
      p.propeller = lerp(p.propeller, p.desired_propel_angle, 0.1)
    end
    if abs(p.propeller-p.desired_propel_angle)<0.001 then
      p.propeller = p.desired_propel_angle
    end
  end
end

-- player_bounds :: player -> bound
function player_bounds(p)
  local bounds = p.bounds

  bounds.top_left.x = p.pos.x
  bounds.top_left.y = p.pos.y

  bounds.bottom_right.x = p.pos.x+p.w-1
  bounds.bottom_right.y = p.pos.y+p.h-1

  return bounds
end

do
  local world_space_collider = {
    top_left     = vec2(),
    bottom_right = vec2(),
  }

  local penetration_vec = vec2()

  function player_resolve_collision(p, airship)
    local is_grounded = false

    for i=1,#airship.colliders do
      -- get some references.
      local p_bounds = player_bounds(p)
      local obstacle = airship.colliders[i]

      -- convert to world space.
      airship_to_world_space(airship, obstacle.top_left,     world_space_collider.top_left)
      airship_to_world_space(airship, obstacle.bottom_right, world_space_collider.bottom_right)

      -- is the player colliding with this collider?
      local is_colliding, side = collides(
        p_bounds,
        world_space_collider,
        penetration_vec
      )

      -- if so, resolve collision.
      if is_colliding then
        vec2_sub_from(penetration_vec, p.pos)
        if penetration_vec.x ~= 0 then p.vel.x = 0 end
        if penetration_vec.y ~= 0 and side == 'bottom' then p.vel.y = 0 end
        if side == 'bottom' then is_grounded = true end
      end
    end

    -- update player's `is_grounded` state.
    p.is_grounded = is_grounded

    return p
  end
end

function player_draw(p)
  rectfill(p.pos.x, p.pos.y, p.pos.x+p.w-1, p.pos.y+p.h-1, 7)

  local x=p.pos.x+cos(p.propeller)*30
  local y=p.pos.y+sin(p.propeller)*30
  rectfill(x,y,x+5,y+5,7)

  print(p.propeller)
  print(p.desired_propel_angle)
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

--
-- bound util.
--

function bound(tlx, tly, brx, bry)
  return {
    top_left     = vec2(),
    bottom_right = vec2(),
  }
end

-- collides :: bound -> bound -> vec2 -> (bool, label, bound)
function collides(bound0, bound1, penetration_vec)
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
  local label = 'top'

  if abs(b) < current_min then
    current_min = abs(b)
    label = 'bottom'
    penetration_vec.x = 0
    penetration_vec.y = b
  end

  if abs(l) < current_min then
    current_min = abs(l)
    label = 'left'
    penetration_vec.x = l
    penetration_vec.y = 0
  end

  if abs(r) < current_min then
    current_min = abs(r)
    label = 'right'
    penetration_vec.x = r
    penetration_vec.y = 0
  end

  return is_colliding, label, diff
end

--
-- airship entity.
--

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

  local mass = 800

  return {
    colliders = colliders,
    pos = vec2(64, 64),
    vel = vec2(),
    acc = vec2(0, config.grav / mass),
    max_vel = vec2(2, .25),
  }
end

function airship_update(a)
  -- update y-component of velocity.
  -- vec2_add_to(a.acc, a.vel)

  -- clamp velocity.
  vec2_clamp_by(a.vel, a.max_vel)

  -- update position.
  vec2_add_to(a.vel, a.pos)

  return a
end

-- airship_to_world_space :: airship -> vec2 -> vec2 -> void
function airship_to_world_space(a, vec_to_convert, out)
  vec2_zero(out)
  vec2_add_to(a.pos, out)
  vec2_add_to(vec_to_convert, out)
end

do
  local v1 = vec2()
  local v2 = vec2()

  function airship_draw(a)
    for i=1,#a.colliders do
      vec2_zero(v1)
      vec2_zero(v2)

      local obstacle = a.colliders[i]

      vec2_add_to(obstacle.top_left, v1)
      vec2_add_to(a.pos,             v1)

      vec2_add_to(obstacle.bottom_right, v2)
      vec2_add_to(a.pos,                 v2)

      rectfill(v1.x, v1.y, v2.x, v2.y, 12)
      pset(v1.x, v1.y, 9)
      pset(v2.x, v2.y, 9)
    end
  end
end
