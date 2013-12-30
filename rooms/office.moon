
import Room from require "room"
import Scene from require "scene"

class BoneScene extends Scene
  bg_image: "images/SCENE_BONES.png"
  sequence: =>
    dialog "It's a bunch of high quality bones you recently acquired."

    dialog "You had to go out of town to get these, but you found the perfect
    spot: a nameless grave in the middle of nowhere."

    dialog "Bones aren't exactly appreciated here in Blood City, mind you.
      Still, these bones make you feel uncomfortable..."

    dialog "...they have a strange feeling about them. Like an extra shadow, or
      an aura. Pretty creepy."

    get_card "bones"

class ComputerScene extends Scene
  bg_image: "images/SCENE_OFFICECOMP.png"

  sequence: =>
    dialog "There's an e-mail on screen."
    dialog [[
      "Damn, nice bones. Real nice. A guy could have a good time
      with those bones. In exchange for the bones, I'll give you
      the bucks...
    ]]

    dialog [[
      Bring them round to my place in a few days.
      I'm at 233 BLOOD STREET. It's the block of apartments by the
      SAD HOUSE.
      - Slugboy"
    ]]

    get_place "lobby"

class OfficeRoom extends Room
  map_name: "office"
  scenes: {
    bones: BoneScene
    computer: ComputerScene
  }

