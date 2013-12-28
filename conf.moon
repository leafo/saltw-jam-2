export game_config = {
  scale: 2
}

love.conf = (t) ->
  t.window.width = 320 * game_config.scale
  t.window.height = 240 * game_config.scale
  t.title = "game"
  t.author = "leafo"
