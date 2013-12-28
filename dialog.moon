
{graphics: g, :timer, :keyboard} = love

import RevealLabel, VList, Label from require "lovekit.ui"

class ChoiceBox extends VList
  waiting: true
  current_choice: 1

  new: (choices, finished_fn) =>
    super 0, 0, [Label c for c in *choices]
    @seq = Sequence ->
      while true
        switch wait_for_key!
          when "up"
            @move -1
          when "down"
            @move 1
          when "x"
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
    @y = world.viewport\bottom @h + 40

    @waiting

  draw: =>
    Box.draw @, {255, 255, 255, 100}
    current =  @items[@current_choice]
    COLOR\push 255, 100, 100
    g.rectangle "fill", current.x - 12, current.y + (current.h / 2) - 3, 6, 6
    COLOR\pop!

    super!


class DialogBox extends Box
  waiting: true
  show_next: false
  alpha: 0

  new: (msg, finished_fn) =>
    @seq = Sequence ->
      await (fn) ->
        @label = RevealLabel msg, 0, 0, fn
        tween @, 0.2, alpha: 255

      @show_next = timer.getTime!
      wait_for_key "x"
      tween @, 0.2, alpha: 0
      @waiting = false
      finished_fn!

  update: (dt, world) =>
    @seq\update dt
    @label\update dt

    @x = world.viewport\left 10
    @y = world.viewport\bottom(10) - @label.h

    @w = world.viewport.w - 20
    @label\set_max_width(@w)
    @h = @label.h

    @label.x = @x
    @label.y = @y

    @waiting

  draw: =>
    unless @alpha == 255
      COLOR\pusha @alpha

    super {255, 255, 255, 100}

    if @show_next and duty_on nil, nil, @show_next
      COLOR\push 255, 100, 100
      g.rectangle "fill", @x + @w - 4, @y + @h - 4, 8, 8
      COLOR\pop!

    @label\draw! if @label

    unless @alpha == 255
      COLOR\pop!


class Dialog extends Sequence
  scope = @default_scope

  @extend {
    dialog: (container, msg) ->
      scope.await (fn) ->
        container.entities\add DialogBox msg, fn

    choice: (container, choices) ->
      scope.await (fn) ->
        container.entities\add ChoiceBox choices, fn

  }

class Head
  w: 100
  h: 100

  new: (@x, @y) =>

  draw: =>
    COLOR\push 241, 221, 87
    g.rectangle "fill", @x, @y, @w, @h
    COLOR\pop!

class TalkScreen
  new: =>
    @viewport = Viewport scale: game_config.scale
    @head = Head 10, 10
    @entities = DrawList!

    @seqs = DrawList!

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
    @entities\draw!

    @head\draw!

    @viewport\pop!

{:TalkScreen}
