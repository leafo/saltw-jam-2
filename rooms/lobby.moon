
import Room from require "room"
import Scene from require "scene"

class ClosedDoorScene extends Scene
  bg_image: "images/NPC_NEIGHBOUR.png"
  sequence: =>
    dialog "Well howdy"
    dispatch\pop!

class LobbyRoom extends Room
  map_name: "lobby"

  scenes: {
    closed_door: ClosedDoorScene
  }
