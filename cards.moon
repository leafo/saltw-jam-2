
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
    @rot = 0

  flip: (immediate=false) =>

  update: (dt) =>
    -- @rot += dt

    -- if @rot > 2
    --   @rot = 0

    true

  draw: =>
    -- super {255, 100, 100}
    hw = @w / 2

    rot = if @rot > 1
      2 - @rot
    else
      @rot

    if rot < 0.5
      sx = (0.5 - rot) * 2
      @sprite\draw @x + hw, @y, 0, sx, 1, hw
    else
      sx = (rot - 0.5) * 2
      @back_sprite\draw @x + hw, @y, 0, sx, 1, hw

    if rot < 0.5
      @label.x = @x + (@w - @label.w) / 2
      @label.y = @y + @h - @label.h - 2
      COLOR\pusha (1 - rot * 2) * 255
      @label\draw!
      COLOR\pop!

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
