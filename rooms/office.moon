
import Room from require "room"
import Scene from require "scene"

class BoneScene extends Scene
  bg_image: "images/SCENE_BONES.png"
  sequence: =>
    dialog "It's a bunch of high quality bones you recently acquired."

    dialog "You had to go out of town to get these, but you found the perfect
    spot: a nameless grave in the middle of nowhere."

    dialog "Bones aren't exactly appreciated here in Bone City, mind you.
      Still, these bones make you feel uncomfortable..."

    dialog "...they have a strange feeling about them. Like an extra shadow, or
      an aura. Pretty creepy."

    unless @game.obtained_cards.bones
      @game.obtained_cards.bones = true
      get_card "bones"

    dispatch\pop!

class ComputerScene extends Scene
  bg_image: "images/SCENE_OFFICECOMP.png"

class OfficeRoom extends Room
  map_name: "office"
  scenes: {
    bones: BoneScene
    computer: ComputerScene
  }

