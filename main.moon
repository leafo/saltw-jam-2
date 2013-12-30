
require "lovekit.all"

{graphics: g, :keyboard} = love

import Room from require "room"

export ez_approach = (val, target, dt) ->
  approach val, target, dt * 10 * math.max 1, math.abs val - target

sealed = (tbl) ->
  setmetatable tbl, {
    __newindex: => error "tried to add to sealed table"
  }

class Game
  new: =>
    @unlocked_places = sealed {
      office: true
      lobby: false
      cemetary: false
    }

    @obtained_cards = sealed {
      bones: false
      knife: false
      murder: false
      slug: false
      spook: false
    }

    @events = sealed {
      seen_body: false
    }

  get_room: (name) =>
    require("rooms.#{name}") @

  get_place: (name) =>
    import TravelScreen from require "travel"
    assert TravelScreen.places[name],
      "unknown place `#{name}`"

  get_unlocked_places: =>
    [k for k,v in pairs(@unlocked_places) when v]

  get_obtained_cards: =>
    import Card from require "cards"
    [Card.cards[k] for k,v in pairs(@obtained_cards) when v]

  @init: =>
    game = Game!
    game\get_room "office"

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

