
import Room from require "room"
import Scene from require "scene"

class BedScene extends Scene
  bg_image: "images/SCENE_BED.png"
  sequence: =>
    dialog "The mattress is stained a deep red. The pool of blood looks fresh but has started to sink into the fabric."

    dialog "It looks like someone was here bleeding for a while, until they got dragged off."

    if "Investigate" == choice { "Investigate", "Walk away" }
      get_card "coolcard"

    dispatch\pop!


class PictureScene extends Scene
  bg_image: "images/SCENE_TORNPIC.png"

class KnifeScene extends Scene
  bg_image: "images/SCENE_KNIFE.png"

class BodyScene extends Scene
  bg_image: "images/SCENE_BODY.png"

class MurderRoom extends Room
  map_name: "murder"

  scenes: {
    bed: BedScene
    picture: PictureScene
    knife: KnifeScene
    body: BodyScene
  }
