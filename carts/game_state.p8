pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function fsm(o)
  assert(o ~= nil and o[1] ~= nil, 'must init fsm.')
  local cur, inst = o[1], o[1].init()
  local function transition(next) cur, inst = next, next.init() end
  function _update60() cur.update(inst, transition) end
  function _draw() cur.draw(inst) end
end

function _init()
  fsm {
    splash
  }
end

--
-- splash state.
--

splash = {}

function splash.init()
  return {
    t  = 0,
    tt = 1 * 60,
  }
end

function splash.update(s, transition_to)
  s.t += 1
  if s.t == s.tt then transition_to(menu) end
end

function splash.draw(s)
  cls(1)
  print('splash screen.')
  print('transitioning in ' .. s.tt-s.t .. ' frames...')
end

--
-- menu state.
--

menu = {}

function menu.init()
  return {}
end

function menu.update(m, transition)
  if btn(5) then transition(game) end
end

function menu.draw(m)
  cls(2)
  print('menu screen.')
  print('press ❎ to start.')
end

--
-- game state.
--

game = {}

function game.init()
  return {
    t  = 0,
    tt = 1 * 60,
  }
end

function game.update(g, transition)
  g.t += 1
  if g.t == g.tt then transition(game_over) end
end

function game.draw(g)
  cls(3)
  print('game screen.')
  print('ending game in ' .. g.tt-g.t .. ' frames...')
end

--
-- game over state.
--

game_over = {}

function game_over.init()
  return {}
end

function game_over.update(g, transition)
  if btn(4) then transition(game) end
end

function game_over.draw(g)
  cls(4)
  print('game over. :(')
  print('press 🅾️ to reset.')
end
