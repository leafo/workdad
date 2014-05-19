
ffi = require "ffi"

ffi.cdef [[
  typedef struct FILE FILE;
  typedef int ssize_t;

  static const int F_GETFL = 3;
  static const int F_SETFL = 4;

  static const int O_RDONLY = 0;
  static const int O_NONBLOCK = 2048;

  static const int EAGAIN = 11;

  FILE *popen(const char *command, const char *type);
  int pclose(FILE *stream);

  int fileno(FILE *stream);
  int fcntl(int fildes, int cmd, ...);

  ssize_t read(int fildes, void *buf, size_t nbyte);

  extern int errno;
]]

popen_nonblock = (cmd) ->
  file = assert ffi.C.popen(cmd, "r"), "failed to open command"
  fd = ffi.C.fileno file
  ffi.C.fcntl fd, ffi.C.F_SETFL, ffi.new("int", ffi.C.O_NONBLOCK)

  unpack_buffer = (buffer, len=0, pos=0) ->
    return if pos >= len
    buffer[pos], unpack_buffer buffer, len, pos + 1

  {
    read: (num=1) =>
      buffer = ffi.new "char[#{num}]"
      res = ffi.C.read fd, buffer, num

      if res == 0
        @close!
        return nil, "eof"

      if res < 0
        if ffi.C.errno == ffi.C.EAGAIN
          return nil, "eagain"
        else
          return nil, "error"

      string.char unpack_buffer buffer, res

    close: =>
      -- this causes crash for some reason?
      -- ffi.C.pclose file
  }

hex = "([%a%d][%a%d])"
patt = "#{hex} #{hex} #{hex}$"

class MidiInput
  new: (@device, @on_event) =>
    @file = popen_nonblock "amidi -d -p #{@device}"
    @buff = ""

  on_event: (a,b,c) =>
    print "got midi event", a,b,c

  close: =>
    @file\close!

  update: (dt) =>
    while true
      char, msg = @file\read 1
      unless char
        if msg == "eof"
          error "lost connection to midi device"

        return

      @buff ..= char

      a,b,c = @buff\match patt
      @on_event a,b,c if a

    true

{ :MidiInput }
