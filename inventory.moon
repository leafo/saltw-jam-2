
{ graphics: g } = love

import Anchor, VList, Label, RevealLabel, Bin from require "lovekit.ui"
import Card from require "cards"

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

  new: (...) =>
    super ...

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
    @viewport = Viewport scale: GAME_CONFIG.scale
    @entities = DrawList!

    cards = @game\get_obtained_cards!
    if next cards
      @setup_cards cards
    else
      @setup_no_cards!

  setup_no_cards: =>
    x,y,w,h = @viewport\unpack!
    @entities\add Bin x,y,w,h, Label("Your inventory is empty")

  setup_cards: (cards) =>
    local *

    left_col_width = @viewport.w - Card.w - 40

    card_data = VList @viewport\left(5), @viewport\top(5), {
      Label "INVENTORY (#{#cards} card#{#cards != 1 and "s" or ""})"
      Box 0,0, 200, 1
    }

    card_list = CardList {
      on_select: (list, item) ->
        label = RevealLabel item.description
        label\set_max_width left_col_width
        card_data.items[3] = label

      unpack cards
    }

    @entities\add Anchor @viewport\right(5), @viewport\top(5), card_list, "right", "top"
    @entities\add card_data


  update: (dt) =>
    @entities\update dt, @viewport

  on_key: (key) =>
    if key == GAME_CONFIG.key.cancel
      dispatch\pop!

  draw: =>
    @viewport\apply!
    @entities\draw!

    @viewport\pop!

{ :InventoryScreen }
