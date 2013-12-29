
{graphics: g} = love

ez_approach = (val, target, dt) ->
  approach val, target, dt * 10 * math.max 1, math.abs val - target

import HList, Label, RevealLabel, CenterBin from require "lovekit.ui"

class Place extends Box
  x: 0
  y: 0

  w: 200
  h: 150

  new: (name, @to, img) =>
    @label = Label name
    @sprite = imgfy img if img

  update: (dt) =>
    @label.y = @y + @h + 5
    @label.x = @x + (@w - @label.w) / 2
    true

  draw: =>
    super {255,255,255, 128}
    @sprite\draw @x, @y if @sprite
    @label\draw!

class PlaceList extends HList
  current_choice: 1
  ox: 0

  new: (v, opts={}) =>
    b = Box 0,0,200,150

    super (v.w - b.w) / 2, (v.h - b.h) / 2, merge {
      padding: 40

      Place "BONE OFFICE", "office"
      Place "APARTMENT LOBBY", "lobby"
    }, opts

    @seq = Sequence ->

      while true
        switch wait_for_key!
          when "left"
            @move -1
          when "right"
            @move 1
          when "x"
            if item = @items[@current_choice]
              @on_select item
  
  move: (dir) =>
    before = @current_choice
    @current_choice = math.max 1, math.min #@items, @current_choice + dir

    if @current_choice == before
      print "play Brrrt"
  
  update: (dt, viewport) =>
    if current = @items[@current_choice]
      @ox = ez_approach @ox, current.x - @x, dt

    @seq\update dt
    super dt

  draw: =>
    g.push!
    g.translate -@ox, 0

    super!
    g.pop!

class TravelScreen
  new: (@game) =>
    @viewport = Viewport scale: GAME_CONFIG.scale
    @entities = DrawList!

    place_list = PlaceList @viewport, {
      on_select: (list, place) ->
        room = @game.rooms[place.to]
        room\place_player "travel"
        dispatch\replace room
    }

    @entities\add place_list
    @entities\add CenterBin @viewport.w/2, 10, RevealLabel "Choose a destination", 0,0, {
      fixed_size: true
    }

  draw: =>
    @viewport\apply!
    @entities\draw dt, @viewport
    @viewport\pop!

  on_key: (key) =>
    if key == "c"
      print "play Brrrt"

  update: (dt) =>
    @entities\update dt

{ :TravelScreen }
