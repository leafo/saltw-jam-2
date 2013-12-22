
{graphics: g, :keyboard} = love

import RevealLabel from require "lovekit.ui"

class Hud
  new: (@world) =>
    @entities = DrawList!

  add: (...) =>
    @entities\add ...

  update: (dt) =>
    @entities\update dt, @world

  draw: =>
    {viewport: v} = @world

    g.push!
    g.translate v.x, v.y
    @entities\draw @world.viewport

    g.pop!

class MessageBox
  padding: 5
  visible: true
  box_color: {0,0,0, 100}

  new: (@text) =>
    @alpha = 0
    @label = RevealLabel @text, 0, 0, -> @hide!
    @seq = Sequence ->
      tween @, 0.3, { alpha: 255 }
      @seq = nil

  draw: (viewport) =>
    left = viewport\left 10
    right = viewport\right 10
    bottom = viewport\bottom 10

    font = g.getFont!
    height = font\getHeight!
    width = right - left

    x = left
    y = bottom - height

    p = @padding

    COLOR\pusha @alpha
    g.push!
    g.translate x, y
    COLOR\push @box_color
    g.rectangle "fill", -p, -p, width + p * 2, height + p * 2
    COLOR\pop!
    -- g.print @text, 0,0
    @label\draw!
    g.pop!
    COLOR\pop!

  hide: =>
    return if @hiding or not @visible
    @hiding = true
    @seq = Sequence ->
      tween @, 0.2, { alpha: 0 }
      @hiding = false
      @visible = false

  update: (dt) =>
    @seq\update dt if @seq
    @label\update dt
    @visible

{ :MessageBox, :Hud }
