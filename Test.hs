f :: Int -> Int
f = _

main = do
  print $ f 4
  print "test"

data Game =
  Game
    { foo :: String
    }

data Airship =
  Airship
    { bar :: String
    }

game_draw :: Game -> IO ()
game_draw = _

data Vec2 =
  Vec2
    { x :: Float
    , y :: Float
    }

data Player =
  Player
    { pos :: Vec2
    , vel :: Vec2
    , acc :: Vec2
    }
