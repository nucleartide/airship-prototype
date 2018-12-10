pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- minkowski sums
-- by @nucleartide

--[[
data bound =
  bound
    { top_left     :: vec2
    , bottom_right :: vec2
    }
]]

-- minkowski_difference :: bound -> bound -> bound
function minkowski_difference(a, b)
  local top    = a.top_left.y     - b.bottom_right.y
  local bottom = a.bottom_right.y - b.top_left.y
  local left   = a.top_left.x     - b.bottom_right.x
  local right  = a.bottom_right.x - b.top_left.x

  return {
    top_left     = vec2(left,  top),
    bottom_right = vec2(right, bottom),
  }
end

-- collides :: bound -> bound -> bool
function collides(a, b)
  local diff = minkowski_difference(a, b)

  -- if the minkowski difference intersects the origin,
  -- then a and b collide.
  return true
    and diff.top_left.x <= 0
    and diff.bottom_right.x >= 0
    and diff.top_left.y <= 0
    and diff.bottom_right.y >= 0
end

function vec2(x, y)
  return {
    x = x or 0,
    y = y or 0,
  }
end

function player()
  return {
    pos = vec2(2, 2),
    w   = 3,
    h   = 4,
  }
end

function player_bounds(p)
  return {
    top_left     = vec2(p.pos.x,     p.pos.y),
    bottom_right = vec2(p.pos.x+p.w, p.pos.y+p.h),
  }
end

function player_update(p)
  if btn(0) then p.pos.x -= 1 end
  if btn(1) then p.pos.x += 1 end
  if btn(2) then p.pos.y -= 1 end
  if btn(3) then p.pos.y += 1 end
  return p
end

function player_draw(p)
  local bounds = player_bounds(p)
  rectfill(
    bounds.top_left.x,
    bounds.top_left.y,
    bounds.bottom_right.x,
    bounds.bottom_right.y,
    8
  )
end

do
  local collider = {
    top_left     = vec2(36, 43),
    bottom_right = vec2(80, 95),
  }

  local p = player()

  local is_colliding = false

  function _update60()
    -- update player
    p = player_update(p)

    -- update `is_colliding` status
    local p_bounds = player_bounds(p)
    is_colliding = collides(p_bounds, collider)
  end

  function _draw()
    cls()
    rectfill(
      collider.top_left.x,
      collider.top_left.y,
      collider.bottom_right.x,
      collider.bottom_right.y,
      7
    )
    player_draw(p)
    print('collides: ' .. tostr(is_colliding), nil, nil, 7)
  end
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