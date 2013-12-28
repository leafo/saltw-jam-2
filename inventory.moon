
{ graphics: g } = love

import VList, Label from require "lovekit.ui"

ez_approach = (val, target, dt) ->
  approach val, target, dt * 10 * math.max 1, math.abs val - target

class Card extends Box
  w: 60
  h: 75

  new: (label) =>
    super 0, 0
    @label = Label label

  update: (dt) =>

  draw: =>
    super {255, 100, 100}
    @label.x = @x + 2
    @label.y = @y + 2
    @label\draw!

class CardList extends VList
  current_choice: 1
  oy: 0
  target_oy: 0

  move: (dir) =>
    before = @current_choice
    @current_choice = math.max 1, math.min #@items, @current_choice + dir

    if @current_choice == before
      print "play Brrrt"

  new: (x,y, cards={}) =>
    super x, y, {
      xalign: "right"
      unpack cards
    }

    @seq = Sequence ->
      while true
        switch wait_for_key!
          when "up"
            @move -1
          when "down"
            @move 1

  draw: =>
    g.push!
    g.translate 0, -@oy

    if current = @items[@current_choice]
      current\scale(1.1, 1.1, true)\draw {255,255,255, 128}

    super!
    g.pop!


  update: (dt, viewport) =>
    if current = @items[@current_choice]
      @target_oy = current.y + current.h/2 - viewport.h/2
      @oy = ez_approach @oy, @target_oy, dt

    @seq\update dt
    super dt

class InventoryScreen
  new: (@game) =>
    @viewport = Viewport scale: game_config.scale
    @entities = DrawList!

    @entities\add CardList @viewport\right(5), @viewport\top(5), {
      Card "Piss\nCard"
      Card "Thug\nCard"
      Card "Lovers\nCard"
      Card "Satan\nCard"
    }

  update: (dt) =>
    @entities\update dt, @viewport

  on_key: (key) =>
    if key == "c"
      dispatch\pop!

  draw: =>
    @viewport\apply!
    @entities\draw!

    @viewport\pop!


{ :InventoryScreen }
