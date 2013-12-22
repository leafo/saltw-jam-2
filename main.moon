
require "lovekit.all"

{graphics: g, :keyboard} = love

class Player extends Entity
  speed: 200

  update: (dt, world) =>
    move = movement_vector!
    dx, dy = unpack move * (dt * @speed)
    @fit_move dx, dy, world
    true

class Game
  new: =>
    sx, sy = 0, 0
    @map = TileMap.from_tiled "maps.first", {
      object: (o) ->
        switch o.name
          when "spawn"
            sx = o.x
            sy = o.y
    }

    @viewport = Viewport scale: 2
    @entities = DrawList!
    @player = Player sx, sy
    @entities\add @player

  draw: =>
    @viewport\center_on @player
    @viewport\apply!
    @map\draw @viewport

    g.print "hello world", 10, 10

    @entities\draw!
    @viewport\pop!

  update: (dt) =>
    @entities\update dt, @

  collides: (entity) =>
    @map\collides entity

load_font = (img, chars)->
  font_image = imgfy img
  g.newImageFont font_image.tex, chars

love.load = ->
  export fonts = {
    default: load_font "images/font1.png", [[ ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~!"#$%&'()*+,-./0123456789:;<=>?]]
  }

  g.setFont fonts.default
  g.setBackgroundColor 30,30,40

  export dispatch = Dispatcher Game!
  dispatch\bind love

