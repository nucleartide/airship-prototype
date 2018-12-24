pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function fsm(o)
  local cur, inst
  local function transition(next) cur, inst = next, next.init() end
  assert(o != nil and o.init != nil, 'must init fsm.')
  transition(o.init)
  function _update60() inst = cur.update(inst, transition) end
  function _draw() cur.draw(inst) end
end

function _init()
  fsm {
    init = splash
  }
end

--
-- splash state.
--

splash = {}

function splash.init()
  return {
    t  = 0,
    tt = 2 * 60,
  }
end

function splash.update(s, transition_to)
  s.t += 1
  if s.t == s.tt then transition_to(menu) end
  return s
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
  return {
    foo   = "bar",
    hello = "world",
  }
end

function menu.update(m)
  return m
end

function menu.draw(m)
  cls(2)
  print('menu screen.')
  print('press ❎ to start.')
end

--
--
--

-- todo: game end
--   high score
--   game over
--   win
--   lose
-- option to reset and play again
-- leads to menu
-- each state should have its own state
