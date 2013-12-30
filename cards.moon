
{ graphics: g } = love

import VList, Label, Anchor from require "lovekit.ui"

fix_str = (str) ->
  str\gsub("\n", " ")\gsub "%s+", " "

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

    @description = fix_str @description

    super 0, 0
    @sprite = imgfy @image
    label = if type(@label) == "table"
      VList {
        xalign: "center"
        padding: 0
        unpack [Label l for l in *@label]
      }
    else
      Label @label

    @label = Anchor 0,0, label, "center", "bottom"
    @rot = 0

  flip: (immediate=false) =>

  update: (dt) =>
    @label.x = @x + @w / 2
    @label.y = @y + @h - 2
    @label\update dt
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
      COLOR\pusha (1 - rot * 2) * 255
      @label\draw!
      COLOR\pop!

Card.cards = lazy_tbl {
  bones: ->
    Card {
      label: "BONES"
      description: "Bones are kind of taboo in Blood City. Selling them can be
      tricky. These bones are very high quality, and well worth a BUCK. You
      can't help but feel a strange presence around them though. The sooner you
      get rid, the better."

      image: "images/card_faecs/CARD_BONES.png"
    }

  knife: ->
    Card {
      label: "KNIFE"
      description: "KNIVES ARE DANGEROUS BUT BLOOD IS COOL, I'M DEEPLY
      CONFLICTED"
      image: "images/card_faecs/CARD_KNIFE.png"
    }

  murder: ->
    Card {
      label: {"MURDER", "LOVER"}
      description: "A message left written in blood. Courier New, 20 pt. You
      think this might be the name of the murderer."
      image: "images/card_faecs/CARD_MURDER.png"
    }

  slug: ->
    Card {
      label: {"SLUG", "BOY"}
      description: "You knew him only as SLUGBOY, through a bone exchange
      website. He was stabbed in the chest and died from a stab in the chest."
      image: "images/card_faecs/CARD_SLUG.png"
    }

  spook: ->
    Card {
      label: {"SPOOK", "BOY"}
      description: "Seems to be a friend of SLUGBOY's. They were going to meet
      up at the graveyard, but then he died."
      image: "images/card_faecs/CARD_SPOOK.png"
    }

}

{ :Card }
