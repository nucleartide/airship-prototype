pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--
-- game loop.
--

function _init()
end

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
  }
end

function game_update(g)
  return g
end

function game_draw(g)
  cls(13)
  print('hiii')
end

--
-- tile entity.
--

function tile(x, y, w, h, c)
  return {
    bounds = bounds(x, y, w, h),
    col = c,
  }
end

function tile_update(t)
  return t
end

function tile_draw(t)
  rectfill(t.bounds.top_left.x, t.bounds.top_left.y, t.bounds.bottom_right.x, t.bounds.bottom_right.y, t.col)
end

--
-- vec2 util.
--

function vec2(x, y)
  return {
    x = x,
    y = y,
  }
end

--
-- bounds util.
--

function bounds(x, y, w, h)
  local top_left     = vec2(x,     y)
  local bottom_right = vec2(x+w-1, y+h-1)

  return {
    top_left     = top_left,
    bottom_right = bottom_right,
  }
end

--[[
pset        :: io ()
game_update :: btn_state -> game -> game
]]
