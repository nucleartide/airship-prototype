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

--[[
pset        :: io ()
game_update :: btn_state -> game -> game
]]
