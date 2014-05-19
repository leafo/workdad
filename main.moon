
require "lovekit.all"

{graphics: g} = love

package.cpath ..= ";/home/leafo/.luarocks/lib/lua/5.1/?.so"
uinput = require "uinput"

import MidiInput from require "midi_input"
import HList, Anchor from require "lovekit.ui"

chords = require "chords"

class Key extends Box
  x: 0
  y: 0
  w: 50
  h: 100

  new: (@key_id) =>

  draw: =>
    if @is_down
      super {255,255,255}
    else
      super {180,180,180}

  update: =>
    true

class ChordTyper
  new: =>
    @is_down = {}
    @total_down = 0

    @midi = MidiInput "hw:2,0,0", @\handle_event
    love.quit = ->
      @midi\close!

    @entities = DrawList!

    @left_hand = HList {
      x: 10
      y: 10

      Key 0
      Key 2
      Key 4
      Key 5
      Key 7
    }

    @right_hand = HList {
      Key 12
      Key 14
      Key 16
      Key 17
      Key 19
    }

    @entities\add @left_hand
    @entities\add Anchor g.getWidth() - 10, 10, @right_hand, "right"

  handle_event: (_, a,b,c) =>
    event = tonumber a, 16
    key = tonumber b, 16
    velocity = tonumber c, 16

    switch event
      when 144 -- down
        return if @is_down[key]
        @is_down[key] = true
        @total_down += 1

      when 128 -- up
        return unless @is_down[key]
        @total_down -= 1

        if @total_down == 0
          @handle_chord [key for key in pairs @is_down]
          @is_down = {}

  handle_chord: (chord) =>
    require("moon").p chord

  update: (dt) =>
    @midi\update dt
    @entities\update dt

    for i, key in ipairs @left_hand.items
      key.is_down = @is_down[key.key_id + chords.offset]

    for i, key in ipairs @right_hand.items
      key.is_down = @is_down[key.key_id + chords.offset]

  draw: =>
    @entities\draw!

class Main
  new: =>
    @typer = ChordTyper!

  draw: =>
    @typer\draw!

  update: (dt) =>
    @typer\update dt

love.load = ->
  DISPATCHER = Dispatcher Main!
  DISPATCHER\bind love

