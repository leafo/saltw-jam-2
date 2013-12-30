
import Room from require "room"
import Scene from require "scene"

class ApartmentRoom extends Room
  map_name: "apartment"

  scenes: {
    bookcase: Scene
    computer: Scene
  }
