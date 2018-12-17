pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- wafflejs
-- by @nucleartide

--[[

  todo:

    - [ ] player moving around

]]

printh('')
printh('game start!')

--
-- config.
--

config = {
  grav = 10, -- newtons
}

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

function game()
  return {
    player = player(),
  }
end

function game_update(g)
  g.player = player_update(btn, g.player)
  return g
end

function game_draw(g)
  cls(1)
  player_draw(g.player)
end

--
-- player entity.
--

function player()
  return {
    pos       = vec2(64, 64),
    vel       = vec2(),
    acc       = vec2(),
    move_vel  = 0.05,
    move_lerp = 0.8,
    w         = 2,
    h         = 2,
    m         = 80,
    max_vel   = vec2(1, 2.5),
    min_vel   = vec2(-1, -2.5),
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

  if p.acc.x ~= 0 then
    -- the line below adds sliding when abruptly changing dir.
    p.vel.x += p.acc.x
  else
    p.vel.x = lerp(p.vel.x, 0, p.move_lerp)
  end

  --
  -- update y-component of velocity.
  --

  local acc = config.grav / p.m
  -- printh('acc: ' .. acc)
  -- p.vel.y += acc

  --
  -- clamp velocity, update position.
  --

  vec2_clamp_between(p.vel, p.min_vel, p.max_vel)
  vec2_add_to(p.vel, p.pos)

  --
  -- return.
  --

  return p
end

function player_draw(p)
  rectfill(p.pos.x, p.pos.y, p.pos.x+p.w-1, p.pos.y+p.h-1, 7)
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
