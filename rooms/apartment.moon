
import Room from require "room"
import Scene from require "scene"

class BookcaseScene extends Scene
  bg_image: "images/SCENE_BOOKCASE.png"
  sequence: =>
    dialog [[
      There are a number of books here on magic and occultism. A few about human
      anatomy, and some Angela Carter short stories.
    ]]


class ComputerScene extends Scene
  bg_image: "images/SCENE_SLUGBOYCOMPUTER.png"
  sequence: =>
    dialog [[
      The screen is filled with DUNGBOOK, a website designed for sharing dung
      with friends.
    ]]

    dialog [[
      There's a message from a person named SPOOKBOY, and though it feels wrong
      to read it...
    ]]

    dialog [[
      .. it is important to remember there is no such thing as privacy on
      DUNGBOOK.
    ]]

    dialog [[
      "Meet me tonight. Same time, same grave. Prepare to get spooked. -
      Spookboy"
    ]]

    dialog [[
      Sounds spooky
    ]]

    get_card "spook"

class ApartmentRoom extends Room
  map_name: "apartment"

  scenes: {
    bookcase: BookcaseScene
    computer: ComputerScene
  }
