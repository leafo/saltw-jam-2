
require "lovekit.all"

{graphics: g, :keyboard} = love

import MessageBox, Hud from require "ui"

class Npc extends Entity
  solid: true

  on_interact: (player, world) =>
    world.hud\add MessageBox "Wanker Piss"

  draw: =>
    super {255,100,100}

  update: (dt, world) =>
    true

class Player extends Entity
  solid: true
  speed: 200

  update: (dt, world) =>
    move = movement_vector!
    dx, dy = unpack move * (dt * @speed)
    @fit_move dx, dy, world
    true

class Game
  new: =>
    sx, sy = 0, 0

    @entities = DrawList!
    @map = TileMap.from_tiled "maps.first", {
      object: (o) ->
        switch o.name
          when "npc"
            @entities\add Npc o.x, o.y
          when "spawn"
            sx = o.x
            sy = o.y
    }

    @viewport = Viewport scale: 2
    @player = Player sx, sy
    @entities\add @player
    @hud = Hud @

    @collide = UniformGrid!

  draw: =>
    @viewport\center_on @player
    @viewport\apply!
    @map\draw @viewport

    @entities\draw!
    @hud\draw!

    @viewport\pop!

  update: (dt) =>
    @collide\clear!
    for e in *@entities
      if e.solid
        @collide\add e

    @entities\update dt, @
    @hud\update dt, @

  on_key: (key) =>
    if key == "x"
      for entity in *@collide\get_touching @player\scale 1.5, 1.5, true
        continue if entity == @player
        if entity.on_interact
          entity\on_interact @player, @

  collides: (entity) =>
    if entity == @player
      for touching in *@collide\get_touching entity
        return true

    @map\collides entity

load_font = (img, chars)->
  font_image = imgfy img
  g.newImageFont font_image.tex, chars

love.load = ->
  export fonts = {
    default: load_font "images/font1.png",[[ ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~!"#$%&'()*+,-./0123456789:;<=>?]]
  }

  g.setFont fonts.default
  g.setBackgroundColor 30,30,40

  export dispatch = Dispatcher Game!
  dispatch\bind love

