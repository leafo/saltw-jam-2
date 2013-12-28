
require "lovekit.all"

{graphics: g, :keyboard} = love

import MessageBox, Hud from require "ui"
import TalkScreen from require "dialog"
import InventoryScreen from require "inventory"

class Npc extends Entity
  solid: true

  on_interact: (world) =>
    dispatch\push TalkScreen!

  on_nearby: (world) =>
    @msg_box = MessageBox "Press 'X' to schmooze"
    world.hud\add_message_box @msg_box

  off_nearby: (world) =>
    if @msg_box
      @msg_box\hide -> @msg_box = nil

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

  touch_radius: =>
    @scale 1.5, 1.5, true

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

    @viewport = Viewport scale: game_config.scale
    @player = Player sx, sy
    @entities\add @player
    @hud = Hud @

    @nearby = {}

    @collide = UniformGrid!

  draw: =>
    COLOR\push 0,0,0
    g.rectangle "fill", 0, 0, g.getWidth!, g.getHeight!
    COLOR\pop!

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

    for entity in *@collide\get_touching @player\touch_radius!
      continue if entity == @player
      unless @nearby[entity]
        if entity.on_nearby
          entity\on_nearby @

      @nearby[entity] = 2

    -- see who is nearby
    for entity,v in pairs @nearby
      @nearby[entity] -= 1
      if @nearby[entity] == 0
        @nearby[entity] = nil
        if entity.off_nearby
          entity\off_nearby @

    @entities\update dt, @
    @hud\update dt, @

  on_key: (key) =>
    switch key
      when "x"
        for entity in *@collide\get_touching @player\touch_radius!
          continue if entity == @player
          if entity.on_interact
            entity\on_interact @
      when "c"
        dispatch\push InventoryScreen @

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
  dispatch.default_transition = FadeTransition
  dispatch\bind love

