
import Room from require "room"
import Scene from require "scene"

class BedScene extends Scene
  bg_image: "images/SCENE_BED.png"
  sequence: =>
    dialog "The mattress is stained a deep red. The pool of blood looks fresh but has started to sink into the fabric."

    dialog "It looks like someone was here bleeding for a while, until they got dragged off."

class PictureScene extends Scene
  bg_image: "images/SCENE_TORNPIC.png"

  sequence: =>
    dialog [[
      There's a large, framed picture of your client, Slugboy.
    ]]

    dialog [[
      The picture is torn in half, but it seems like there should be another
      person here.
    ]]

class KnifeScene extends Scene
  bg_image: "images/SCENE_KNIFE.png"

  sequence: =>
    dialog [[
      This is a sharp knife, plunged into the wall with some force. It'd take
      some strength to pull it out.
    ]]

    dialog [[
      The long blade is coated with a thin layer of blood. On the wall is a
      message... "MURDER LOVER". The message is written in blood...
    ]]

    dialog [[
      There is so much blood here...
    ]]

    get_card "knife"
    get_card "murder"

class BodyScene extends Scene
  bg_image: "images/SCENE_BODY.png"

  sequence: =>
    if @game.events.seen_body
      dialog [[
        Slugboy is still here. Still dead. The blood is no longer pouring from
        his chest, but it is still a pretty shocking sight.
      ]]

      dialog [[
        Hopefully nobody wanders in and sees this...
      ]]
      return

    @game.events.seen_body = true

    dialog [[
      Your heart sinks as you see the slumped heap of flesh-coloured blood
      lying on the floor.
    ]]

    dialog [[
      It is without a doubt your client, you recognise his face from the "Post
      Your Skull" thread on the bone exchange website.

    ]]

    dialog [[
      Looking closer, you can see a lot of blood flowing from a fatal stab
      wound to the chest.
    ]]

    dialog [[
      Judging from the size of the pool of blood, you figure he's been slumped
      here for a while...
    ]]

    dialog [[
      ...but the trail of blood leading from the bed suggests he was moved
      after being stabbed.
    ]]

    dialog [[
      Your immediate reaction is to run away, but you have nowhere to run.
    ]]

    dialog [[
      You've no doubt left traces around the place, and the cops would come to
      you sooner or later.
    ]]

    dialog [[
      For a moment you contemplate going to the cops, but the last time you did
      you got thrown in jail.
    ]]

    dialog [[
      Seems like the Blood Cops have a bone to pick with you.
    ]]

    dialog [[
      So your solution is simple: find the murderer, and take them to the cops.
    ]]

    dialog [[
      For now, Slugboy is going to have to stay collapsed on the floor.
    ]]

    get_card "slug"

class MurderRoom extends Room
  map_name: "murder"

  scenes: {
    bed: BedScene
    picture: PictureScene
    knife: KnifeScene
    body: BodyScene
  }

