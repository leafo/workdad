
require "lovekit.all"

package.cpath ..= ";/home/leafo/.luarocks/lib/lua/5.1/?.so"
uinput = require "uinput"

import MidiInput from require "midi_input"

class Main
  new: =>
    @midi = MidiInput "hw:2,0,0"
    love.quit = ->
      @midi\close!

  draw: =>

  update: (dt) =>
    @midi\update!

love.load = ->
  DISPATCHER = Dispatcher Main!
  DISPATCHER\bind love
  
