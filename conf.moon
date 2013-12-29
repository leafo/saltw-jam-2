export GAME_CONFIG = {
  scale: 2
  key: {
    confirm: "x"
    cancel: "c"
  }
}

love.conf = (t) ->
  t.window.width = 320 * GAME_CONFIG.scale
  t.window.height = 240 * GAME_CONFIG.scale
  t.title = "game"
  t.author = "leafo"
