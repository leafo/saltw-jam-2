
require "lovekit.all"

{graphics: g, :keyboard} = love

import Room from require "room"

class Game
  @init: =>
    game = Game!
    game.rooms.first

  new: =>
    @rooms = setmetatable {}, __index: (tbl, name) ->
      with r = Room @, name
        tbl[name] = r

load_font = (img, chars)->
  font_image = imgfy img
  g.newImageFont font_image.tex, chars

love.load = ->
  export fonts = {
    default: load_font "images/font1.png", [[ ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~!"#$%&'()*+,-./0123456789:;<=>?]]
  }

  g.setFont fonts.default
  g.setBackgroundColor 30,30,40

  export dispatch = Dispatcher Game\init!
  dispatch.default_transition = FadeTransition
  dispatch\bind love

