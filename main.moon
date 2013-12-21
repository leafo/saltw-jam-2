
require "lovekit.all"

{graphics: g, :keyboard} = love

class Game
  new: =>
    @viewport = Viewport scale: 2

  draw: =>
    @viewport\apply!
    g.print "hello world", 10, 10
    @viewport\pop!

  update: (dt) =>

load_font = (img, chars)->
  font_image = imgfy img
  g.newImageFont font_image.tex, chars

love.load = ->
  export fonts = {
    default: load_font "images/font1.png", [[ ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~!"#$%&'()*+,-./0123456789:;<=>?]]
  }

  g.setFont fonts.default
  g.setBackgroundColor 30,30,40

  export dispatch = Dispatcher Game!
  dispatch\bind love

