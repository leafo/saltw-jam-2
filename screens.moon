
{graphics: g} = love

class Dialog extends Sequence
  @extend {
    dump: =>
      print "meetgs and greets"
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
    @seqs = DrawList!

    @seqs\add Dialog ->
      dump!

  update: (dt) =>
    @seqs\update dt

  draw: =>
    @viewport\apply!

    @head\draw!

    @viewport\pop!


{:TalkScreen}
