
{graphics: g, :timer, :keyboard} = love

import RevealLabel from require "lovekit.ui"

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
    @label\update dt if @label

    @x = world.viewport\left 10
    @y = world.viewport\bottom(10) - @label.h

    @w = world.viewport.w - 20
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
  @extend {
    dialog: (container, msg) ->
      Sequence.default_scope.await (fn) ->
        container.entities\add DialogBox msg, fn
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
    @viewport = Viewport scale: 2
    @head = Head 10, 10
    @entities = DrawList!

    @seqs = DrawList!

    @seqs\add Dialog ->
      dialog @, "Here is the first dialog message"
      dialog @, "Here is the next dialog message"

  update: (dt) =>
    @seqs\update dt
    @entities\update dt, @

  draw: =>
    @viewport\apply!
    @entities\draw!

    @head\draw!

    @viewport\pop!


{:TalkScreen}
