offset = 48

fingers = {
  left: {
    thumb: 7
    pointer: 5
    middle: 4
    ring: 2
    pinky: 0
  }
  right: {
    thumb: 12
    pointer: 14
    middle: 16
    ring: 17
    pinky: 19
  }
}


chords = {
  "0": { "KEY_A" }
  "2": { "KEY_B" }
  "4": { "KEY_C" }
  "5": { "KEY_D" }
  "7": { "KEY_E" }

  "12": { "KEY_F" }
  "14": { "KEY_G" }
  "16": { "KEY_H" }
  "17": { "KEY_I" }
  "19": { "KEY_J" }

  -- thumb on opposite
  "0-12": { "KEY_K" }
  "2-12": { "KEY_L" }
  "4-12": { "KEY_M" }
  "5-12": { "KEY_N" }
  "7-12": { "KEY_O" }

  "7-13": { "KEY_P" }
  "7-14": { "KEY_Q" }
  "7-16": { "KEY_R" }
  "7-17": { "KEY_S" }
  "7-19": { "KEY_T" }

  -- pointer on opposite
  "0-14": { "KEY_U" }
  "2-14": { "KEY_V" }
  "4-14": { "KEY_W" }
  "5-14": { "KEY_X" }
  "7-14": { "KEY_Y" }

  "5-12": { "KEY_Z" }
  "5-14": { "KEY_SPACE" }
  "5-16": { "KEY_BACKSPACE" }
  "5-17": { "KEY_ENTER" }
  -- "5-19": { }
}

{ :chords, :fingers, :offset }
