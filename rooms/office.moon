
import Room from require "room"
import Scene from require "scene"

class BoneScene extends Scene
  bg_image: "images/SCENE_BONES.png"

class ComputerScene extends Scene
  bg_image: "images/SCENE_OFFICECOMP.png"

class OfficeRoom extends Room
  map_name: "office"
  scenes: {
    bones: BoneScene
    computer: ComputerScene
  }

