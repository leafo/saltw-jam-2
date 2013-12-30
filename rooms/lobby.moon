
import Room from require "room"
import Scene from require "scene"

import insert from table

class ClosedDoorScene extends Scene
  bg_image: "images/NPC_NEIGHBOUR.png"
  sequence: =>
    dialog [[
      You knock on the door, and a man appears.
    ]]

    dialog [[
      He stares at you with an almost murderous grin, his skull-like head raised
      slightly, as if he were staring down inside of you.
    ]]

    dialog [[
      It makes you feel fucked up.
    ]]

    choices = {"Leave"}

    if @game.events.seen_body
      dialog [[
        He notices your hand trembling about the same time you do.
      ]]

      dialog [[
        You only just realised, but the shock of seeing blood has kind of
        messed you up.
      ]]

      dialog [[
        He sees this, and his eyes widen. Could he tell?
      ]]

      if @game.obtained_cards.spook
        insert choices, "SPOOKBOY"

      if @game.obtained_cards.knife
        insert choices, "KNIFE"

      if @game.obtained_cards.slug
        insert choices, "SLUGBOY"

      if @game.obtained_cards.murder
        insert choices, "MURDER LOVER"


    else
      dialog [[
        "Hmm..."
      ]]

    if @game.obtained_cards.bones
      insert choices, "BONES"

    while true
      switch choice choices
        when "Leave"
          break
        when "BONES"
          dialog [[
            "Bones? I don't want anything to do with bones, buddy. This is Blood
            City, bones are useless!! Bones are piss!!"
          ]]
        when "KNIFE"
          dialog [[
            "Knives? The only thing I know about knives is they make the blood come out."
          ]]
          dialog [[
            "Why would I know anything about knives? What are you suggesting, buddy?"
          ]]
        when "SLUGBOY"
          dialog [[
            The bulges of flesh around his face seem to collapse into the
            middle, as a deep frown forms.
          ]]

          dialog [[
            "I've got nothing to say about those two creeps."
          ]]
        when "MURDER LOVER"
          dialog [[
            "Hmm... I don't get it. Blood lover, sure, everyone loves blood...
            But murder seems a little too much to me..."
          ]]
        when "SPOOKBOY"
          dialog [[
            The smirk on the man's face fades into a more concerned look. He
            seems a little unsettled.
          ]]

          dialog [[
            "There's something wrong with that kid... Both of them... Always hanging out
            that Cemetery down the road..."
          ]]

          dialog [[
            "If I didn't know better, I'd say they were really into bones. And
            that is a pretty dangerous thing to be fascinated by in Blood
            City..."
          ]]

          get_place "cemetery"

class LobbyRoom extends Room
  map_name: "lobby"

  scenes: {
    closed_door: ClosedDoorScene
  }
