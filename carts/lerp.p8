pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--
-- lerp.
--

function lerp(a, b, t)
  return (1-t)*a + t*b
end

--
-- lerp, but wrap around at 0 and 1.
--
-- for example, lerping from 0.1 to 0.9 will lerp from 0.1 to 0,
-- then from 1 to 0.9.
--

function angle_lerp(a, b, t)
  local diff = abs(a-b)
  if diff > 0.5 then
    if a > b then
      a -= 1
    else
      b -= 1
    end
  end
  return lerp(a, b, t) % 1
end

local tests = {
  {{0.9, 0.1, 0.25}, 0.95},
  {{0.9, 0.1, 0.5},  1},
  {{0.9, 0.1, 0.75}, 0.05},
  {{0.9, 0.1, 1},    0.1},

  {{0.1, 0.9, 0.25}, 0.05},
  {{0.1, 0.9, 0.5},  1},
  {{0.1, 0.9, 0.75}, 0.95},
  {{0.1, 0.9, 1},    0.9},
}

for t in all(tests) do
  local case     = t[1]
  local actual   = angle_lerp(case[1], case[2], case[3])
  local expected = t[2]
  local diff     = abs(actual - expected)
  local msg      = 'angle_lerp(' .. case[1] .. ', ' .. case[2] .. ', ' .. case[3] ..  ') == ' .. actual .. ' != ' .. expected
  assert(diff < 0.01, msg)
end
