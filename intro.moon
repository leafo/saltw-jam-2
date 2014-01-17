
import Scene from require "scene"

SCENES = {
  class extends Scene
    bg_image: "images/INTRO_1.png"
    sequence: =>
      dialog [[
        This is the first scene
      ]]


  class extends Scene
    bg_image: "images/INTRO_2.png"
    sequence: =>
      dialog [[
        This is the second scene
      ]]

  class extends Scene
    bg_image: "images/INTRO_3.png"
    sequence: =>
      dialog [[
        This is the third scene
      ]]

}

class Intro
  scene_idx: 0

  new: (@game) =>

  on_show: (init) =>
    @scene_idx += 1
    next_scene = SCENES[@scene_idx]

    if next_scene
      dispatch\push next_scene!
    else
      error "push game"

  update: (dt) =>
  draw: =>

{ :Intro }
