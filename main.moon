
require "lovekit.all"

package.cpath ..= ";/home/leafo/.luarocks/lib/lua/5.1/?.so"
uinput = require "uinput"

import MidiInput from require "midi_input"

class ChordTyper
  new: =>
    @is_down = {}
    @total_down = 0

    @midi = MidiInput "hw:2,0,0", @\handle_event
    love.quit = ->
      @midi\close!

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

  draw: =>

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

