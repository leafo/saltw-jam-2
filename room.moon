
{graphics: g} = love

import MessageBox from require "ui"
import TalkScreen from require "dialog"
import Hud from require "ui"
import InventoryScreen from require "inventory"

has_message_box = (cls, msg) ->
  cls.__base.on_nearby = (world) =>
    @msg_box = MessageBox msg
    world.hud\add_message_box @msg_box

  cls.__base.off_nearby = (world) =>
    if @msg_box
      @msg_box\hide -> @msg_box = nil

class Door extends Box
  w: 10
  h: 10

  has_message_box @, "Press 'X' to enter door"

  new: (x, y, @to) =>
    super 0, 0
    @move_center x, y

  on_interact: (world) =>
    room = world.game.rooms[@to]
    room\place_player world.name

    dispatch\replace room

  draw: =>
    super {255, 100, 255, 64}

  update: => true

class Npc extends Entity
  solid: true
  has_message_box @, "Press 'X' to schmooze"

  on_interact: (world) =>
    dispatch\push TalkScreen!

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

class Room
  new: (@game, @name) =>
    @viewport = Viewport scale: game_config.scale
    @entities = DrawList!
    @doors = {}

    @map = TileMap.from_tiled "maps.#{@name}", {
      object: (o) ->
        switch o.name
          when "door"
            door = Door o.x, o.y, o.properties.to
            @doors[door.to] = door
            @entities\add door
          when "npc"
            @entities\add Npc o.x, o.y
          when "spawn"
            @sx = o.x
            @sy = o.y
    }

    @player = Player @sx, @sy
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

  on_key: (key) =>
    switch key
      when "x"
        for entity in *@collide\get_touching @player\touch_radius!
          continue if entity == @player
          if entity.on_interact
            entity\on_interact @
      when "c"
        dispatch\push InventoryScreen @

  update: (dt) =>
    @collide\clear!

    for e in *@entities
      if e.solid or e.on_nearby
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

  collides: (entity) =>
    if entity == @player
      for touching in *@collide\get_touching entity
        return true if touching.solid

    @map\collides entity

  place_player: (source) =>
    @player\move_center @doors[source]\center!


{ :Room }
