
{ graphics: g } = love

import VList, Label, RevealLabel from require "lovekit.ui"

ez_approach = (val, target, dt) ->
  approach val, target, dt * 10 * math.max 1, math.abs val - target

class Card extends Box
  w: 60
  h: 75

  new: (label="Card", @detailed_label="...") =>
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
    else
      @on_select @items[@current_choice]

  new: (x,y, cards={}) =>
    cards.xalign or= "right"
    super x, y, cards

    @seq = Sequence ->
      if item = @items[@current_choice]
        @on_select item

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

  on_select: (item) =>
    -- override me


class InventoryScreen
  new: (@game) =>
    @viewport = Viewport scale: game_config.scale
    @entities = DrawList!

    local *

    left_col_width = @viewport.w - Card.w - 20

    card_data = VList @viewport\left(5), @viewport\top(5), {
      with Box(0,0,left_col_width, 100)
        .draw = =>
          COLOR\pusha 64
          Box.draw @
          g.print "Item picture goes here...", @x + 5, @y + 5
          COLOR\pop!
    }

    card_list = CardList @viewport\right(5), @viewport\top(5), {
      Card "Piss\nCard", "This card is about 1 thing and that's freaking piss"
      Card "Thug\nCard", "Once a thug forever a man of the streets, wiser by the night and more HUNGRY when mum forgets to feed you"
      Card "Lovers\nCard", "Making love is a way of life I explain to my inflatable partner"
      Card "Satan\nCard", "Let your demons out, show me your spunk"

      on_select: (list, item) ->
        label = RevealLabel item.detailed_label
        label\set_max_width left_col_width
        card_data.items[2] = label
    }

    @entities\add card_list
    @entities\add card_data


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
