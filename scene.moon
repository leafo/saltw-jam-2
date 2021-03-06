
{graphics: g, :timer, :keyboard} = love

import CenterAnchor, Bin, HList, RevealLabel, VList, Label from require "lovekit.ui"

box_bx_color = {0,0,0, 80}

fix_str = (str) ->
  str\gsub("\n", " ")\gsub "%s+", " "

draw_tick = (x,y, w=6) ->
  ow = w + 2
  ow2 = ow/2

  g.rectangle "fill", x - ow2, y - ow2, ow, ow
  w2 = w/2
  COLOR\push 255, 100, 100
  g.rectangle "fill", x - w2, y - w2, w, w
  COLOR\pop!


class GetPlace extends Box
  alpha: 0
  waiting: true
  bg_color: {0,0,0, 128}

  new: (place, fn) =>
    @entities = DrawList!
    @content = VList {
      xalign: "center"
      Label "You unlocked a new place"
      Label '"'.. place.name .. '"'
      Label "" -- spacer
      Label "" -- spacer 2
    }

    @anchor = CenterAnchor 0,0, @content

    @entities\add @anchor

    @seq = Sequence ->
      tween @, 0.8, alpha: 255

      @content.items[4] = RevealLabel "Press 'X' to continue",
        0,0, fixed_size: true

      wait_for_key GAME_CONFIG.key.confirm

      tween @, 1, alpha: 0
      wait 0.1

      fn! if fn

  update: (dt, world) =>
    @x, @y, @w, @h = world.viewport\unpack!
    @anchor.x, @anchor.y = @center!

    @entities\update dt
    @seq\update dt

  draw: =>
    COLOR\pusha @alpha
    super @bg_color
    @entities\draw!
    COLOR\pop!

class GetCard extends Box
  alpha: 0
  waiting: true
  bg_color: {0,0,0, 128}

  new: (card_name, fn) =>
    @entities = DrawList!
    import Card from require "cards"

    card = assert Card.cards[card_name],
      "unknown card #{card_name}"

    @content = VList {
      xalign: "center"

      draw: =>
        g.push!
        g.translate 0, -30
        @__class.draw @
        g.pop!

      Label "You got a card"
      card
      Label " " -- spacer
    }

    @anchor = CenterAnchor 0,0, @content

    @entities\add @anchor

    @seq = Sequence ->
      card.rot = 1
      tween @, 0.8, alpha: 255
      tween card, 1, rot: 0

      @content.items[3] = RevealLabel "Press 'X' to continue",
        0,0, fixed_size: true

      wait_for_key GAME_CONFIG.key.confirm

      tween @, 1, alpha: 0
      wait 0.1

      fn! if fn

  draw: =>
    COLOR\pusha @alpha
    super @bg_color
    @entities\draw!
    COLOR\pop!

  update: (dt, world) =>
    @x, @y, @w, @h = world.viewport\unpack!
    @anchor.x, @anchor.y = @center!

    @entities\update dt
    @seq\update dt

class ChoiceBox extends VList
  waiting: true
  current_choice: 1
  bottom_offset: 10
  tick_y: nil
  target_tick_y: nil

  new: (choices, finished_fn) =>
    super 0, 0, [Label c for c in *choices]
    @create_time = timer.getTime!
    @seq = Sequence ->
      while true
        switch wait_for_key!
          when GAME_CONFIG.key.up
            @move -1
          when GAME_CONFIG.key.down
            @move 1
          when GAME_CONFIG.key.confirm
            break
        @create_time = timer.getTime!

      @waiting = false
      finished_fn choices[@current_choice]

  move: (dir) =>
    before = @current_choice
    @current_choice = math.max 1, math.min #@items, @current_choice + dir
    current =  @items[@current_choice]

    @target_tick_y = current.y + (current.h / 2)
    @tick_y = @target_tick_y if @tick_y == nil

    if dir != 0 and @current_choice == before
      print "play Brrrt"

  update: (dt, world) =>
    super dt
    @seq\update dt if @seq

    if @target_tick_y
      @tick_y = ez_approach @tick_y, @target_tick_y, dt * 2

    @x = world.viewport\right @w + 10
    @y = world.viewport\bottom @h + @bottom_offset


    @waiting

  draw: =>
    Box.draw @, box_bx_color
    current =  @items[@current_choice]

    if not @tick_y and current.y != 0  -- hak attack
      @move 0

    if @tick_y and duty_on nil, nil, @create_time
      draw_tick current.x - 9, @tick_y

    super!


class DialogBox extends Box
  waiting: true
  show_next: false
  alpha: 0

  x: 0
  y: 0

  new: (msg, finished_fn) =>
    msg = fix_str msg
    @seq = Sequence ->
      await (fn) ->
        @label = RevealLabel msg, 0, 0, {
          fixed_size: true
          fn
        }

        tween @, 0.2, alpha: 255

      @show_next = timer.getTime!
      wait_for_key GAME_CONFIG.key.confirm
      @show_next = false
      finished_fn!

      wait_until -> not @waiting
      tween @, 0.2, alpha: 0

  update: (dt, world) =>
    mult = if keyboard.isDown GAME_CONFIG.key.cancel
      4
    else
      1

    running = @seq\update dt
    @label\update dt * mult

    @w = world.viewport.w - 20
    @label\set_max_width(@w)
    @h = @label.h

    @label.x = @x
    @label.y = @y

    running

  draw: =>
    unless @alpha == 255
      COLOR\pusha @alpha

    super box_bx_color

    if @show_next and duty_on nil, nil, @show_next
      draw_tick @x + @w, @y + @h

    @label\draw! if @label

    unless @alpha == 255
      COLOR\pop!


class Dialog extends Sequence
  scope = @default_scope

  @extend {
    get_card: (parent, card) ->
      {:game} = parent
      return if game.obtained_cards[card]
      game.obtained_cards[card] = true

      scope.await (fn) ->
        parent.entities\add GetCard card, fn

    get_place: (parent, place_name) ->
      {:game} = parent
      return if game.unlocked_places[place_name]

      place = game\get_place place_name
      game.unlocked_places[place_name] = true

      scope.await (fn) ->
        parent.entities\add GetPlace place, fn

    dialog: (parent, msg) ->
      scope.await (fn) ->
        parent\add_dialog DialogBox msg, fn

    choice: (parent, choices) ->
      scope.await (fn) ->
        parent.entities\add with ChoiceBox choices, fn
          if d = parent.current_dialog
            .bottom_offset = parent.viewport.h - d.y + 10
  }

  -- bind all methods
  new: (fn, parent) =>
    scope = setmetatable {}, __index: @@default_scope
    for k,v in pairs @@default_scope
      scope[k] = (...) ->v parent, ...

    super fn, scope, parent

class Scene
  bg_image: ""
  verb: "examine"
  sequence: =>
    wait_for_key GAME_CONFIG.key.cancel, GAME_CONFIG.key.confirm

  new: (@game) =>
    @viewport = Viewport scale: GAME_CONFIG.scale
    @entities = EntityList!

    @seqs = DrawList!
    @bg = imgfy @bg_image

    if @sequence
      wrapped = (...) ->
        run @sequence, ...
        @end_scene!

      @seqs\add Dialog wrapped, @

  end_scene: =>
    dispatch\pop!

  add_dialog: (dialog) =>
    if @current_dialog
      @current_dialog.waiting = false

    @current_dialog = dialog
    @entities\add Bin 0, @viewport\bottom(76), @viewport.w, 76, dialog

  update: (dt) =>
    @seqs\update dt
    @entities\update dt, @

  draw: =>
    @viewport\apply!
    @bg\draw 0, 0
    @entities\draw!
    @viewport\pop!

{:Scene}
