
{graphics: g} = love

import MessageBox from require "ui"
import Scene from require "scene"
import Hud from require "ui"
import InventoryScreen from require "inventory"
import TravelScreen from require "travel"

has_message_box = (cls, msg) ->
  cls.__base.on_nearby = (world) =>
    @msg_box = MessageBox msg or @interact_message
    world.hud\add_message_box @msg_box

  cls.__base.off_nearby = (world) =>
    if @msg_box
      @msg_box\hide -> @msg_box = nil

class Door extends Box
  w: 10
  h: 10
  solid: false

  has_message_box @, "Press 'X' to enter door"

  new: (x, y, @to) =>
    super 0, 0
    @move_center x, y

  on_interact: (world) =>
    room = world.game\get_room @to
    room\place_player world.name

    dispatch\replace room

  draw: =>
    super {255, 100, 255, 64}

  update: => true

class SceneTrigger extends Entity
  solid: false
  has_message_box @

  new: (x,y, w, h, @scene_cls) =>
    super x,y,w,h
    @interact_message = "Press 'X' to #{@scene_cls.verb}"

  on_interact: (world) =>
    {:scene_cls} = @
    dispatch\push scene_cls world

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
  sx: 0, sy: 0

  scenes: {}
  map_name: ""

  new: (@game) =>
    @viewport = Viewport scale: GAME_CONFIG.scale
    @entities = DrawList!
    @doors = {}

    @create_map!
    @player = Player @sx, @sy

    @entities\add @player

    @hud = Hud @
    @nearby = {}
    @collide = UniformGrid!

  create_map: =>
    @map = TileMap.from_tiled "maps.#{@map_name}", {
      object: (o) ->
        switch o.name
          when "door"
            door = Door o.x, o.y, o.properties.to
            @doors[door.to] = door
            @entities\add door
          when "scene"
            name = o.properties.name
            scene_cls = assert @scenes[name], "Missing scene #{name}"
            @entities\add SceneTrigger o.x, o.y, o.width, o.height, scene_cls
          when "spawn"
            @sx = o.x
            @sy = o.y
    }

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
      when GAME_CONFIG.key.confirm
        for entity in *@collide\get_touching @player\touch_radius!
          continue if entity == @player
          if entity.on_interact
            entity\on_interact @
      when GAME_CONFIG.key.cancel
        dispatch\push InventoryScreen @game

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
    @player\move_center assert(@doors[source], "couldn't find #{source} door")\center!


{ :Room }
