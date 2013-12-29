
{graphics: g, :timer, :keyboard} = love

import RevealLabel, VList, Label from require "lovekit.ui"

box_bx_color = {0,0,0, 80}

draw_tick = (x,y, w=6) ->
  ow = w + 2
  ow2 = ow/2

  g.rectangle "fill", x - ow2, y - ow2, ow, ow
  w2 = w/2
  COLOR\push 255, 100, 100
  g.rectangle "fill", x - w2, y - w2, w, w
  COLOR\pop!

class ChoiceBox extends VList
  waiting: true
  current_choice: 1
  bottom_offset: 10

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

      @waiting = false
      finished_fn choices[@current_choice]

  move: (dir) =>
    before = @current_choice
    @current_choice = math.max 1, math.min #@items, @current_choice + dir

    if @current_choice == before
      print "play Brrrt"

  update: (dt, world) =>
    super dt
    @seq\update dt if @seq

    @x = world.viewport\right @w + 10
    @y = world.viewport\bottom @h + @bottom_offset

    @waiting

  draw: =>
    Box.draw @, box_bx_color
    current =  @items[@current_choice]

    if duty_on nil, nil, @create_time
      draw_tick current.x - 9, current.y + (current.h / 2)
    super!


class DialogBox extends Box
  waiting: true
  show_next: false
  alpha: 0

  new: (msg, finished_fn) =>
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

    @x = world.viewport\left 10
    @y = world.viewport\bottom(10) - @label.h

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
    get_card: (parent) ->

    dialog: (parent, msg) ->
      scope.await (fn) ->
        if parent.current_dialog
          parent.current_dialog.waiting = false

        parent.current_dialog = DialogBox msg, fn
        parent.entities\add parent.current_dialog

    choice: (parent, choices) ->
      scope.await (fn) ->
        parent.entities\add with ChoiceBox choices, fn
          if d = parent.current_dialog
            .bottom_offset = ChoiceBox.bottom_offset * 2 + d.h
  }

class TalkScreen
  image: "images/SCENE_BED.png"

  new: =>
    @viewport = Viewport scale: GAME_CONFIG.scale
    @entities = DrawList!

    @seqs = DrawList!
    @bg = imgfy @image

    @seqs\add Dialog ->
      dialog @, "Pick one of these choices and I'll fart yr face there Pal"
      res = choice @, {
        "Yes"
        "No"
      }

      if res == "Yes"
        dialog @, "You picked yes"
      else
        dialog @, "Sod off mate"

      dispatch\pop!

  update: (dt) =>
    @seqs\update dt
    @entities\update dt, @

  draw: =>
    @viewport\apply!
    @bg\draw 0, 0

    @entities\draw!

    @viewport\pop!

{:TalkScreen}
