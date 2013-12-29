
{ graphics: g } = love

import Label from require "lovekit.ui"

class Card extends Box
  w: 60
  h: 75

  lazy {
    back_sprite: -> imgfy "images/CARD_BACK.png"
    label: -> error "give label"
    description: -> error "give description"
  }

  new: (opts={}) =>
    for k,v in pairs opts
      @[k] = v

    super 0, 0
    @sprite = imgfy @image
    @label = Label @label

  flip: (immediate=false) =>

  update: (dt) =>

  draw: =>
    super {255, 100, 100}
    @sprite\draw @x, @y
    @label.x = @x + (@w - @label.w) / 2
    @label.y = @y + 2
    @label\draw!

Card.cards = lazy_tbl {
  bones: ->
    Card {
      label: "BONES"
      description: "Bones are cool"
      image: "images/card_faecs/CARD_BONES.png"
    }

  knife: ->
    Card {
      label: "KNIFE"
      description: "The knife"
      image: "images/card_faecs/CARD_KNIFE.png"
    }

  murder: ->
    Card {
      label: "MURDER"
      description: "The murder"
      image: "images/card_faecs/CARD_MURDER.png"
    }

  slug: ->
    Card {
      label: "SLUG"
      description: "The slug"
      image: "images/card_faecs/CARD_SLUG.png"
    }

  spook: ->
    Card {
      label: "MURDER"
      description: "The spook"
      image: "images/card_faecs/CARD_SPOOK.png"
    }



}

{ :Card }
