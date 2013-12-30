
import Room from require "room"
import Scene from require "scene"

class OfficeRoom extends Room
  map_name: "office"
  scenes: {
    bones: Scene
    computer: Scene
  }

