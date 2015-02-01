require 'ffi'

module Mad
  # Low level FFI Bindings to libtermbox
  module Termbox
    extend FFI::Library

    ffi_lib '/usr/local/lib/libtermbox.dylib'

    TB_KEY_F1 =           (0xFFFF - 0)
    TB_KEY_F2 =           (0xFFFF - 1)
    TB_KEY_F3 =           (0xFFFF - 2)
    TB_KEY_F4 =           (0xFFFF - 3)
    TB_KEY_F5 =           (0xFFFF - 4)
    TB_KEY_F6 =           (0xFFFF - 5)
    TB_KEY_F7 =           (0xFFFF - 6)
    TB_KEY_F8 =           (0xFFFF - 7)
    TB_KEY_F9 =           (0xFFFF - 8)
    TB_KEY_F10 =          (0xFFFF - 9)
    TB_KEY_F11 =          (0xFFFF - 10)
    TB_KEY_F12 =          (0xFFFF - 11)
    TB_KEY_INSERT =       (0xFFFF - 12)
    TB_KEY_DELETE =       (0xFFFF - 13)
    TB_KEY_HOME =         (0xFFFF - 14)
    TB_KEY_END =          (0xFFFF - 15)
    TB_KEY_PGUP =         (0xFFFF - 16)
    TB_KEY_PGDN =         (0xFFFF - 17)
    TB_KEY_ARROW_UP =     (0xFFFF - 18)
    TB_KEY_ARROW_DOWN =   (0xFFFF - 19)
    TB_KEY_ARROW_LEFT =   (0xFFFF - 20)
    TB_KEY_ARROW_RIGHT =  (0xFFFF - 21)

    TB_KEY_CTRL_TILDE =      0x00
    TB_KEY_CTRL_2 =          0x00
    TB_KEY_CTRL_A =          0x01
    TB_KEY_CTRL_B =          0x02
    TB_KEY_CTRL_C =          0x03
    TB_KEY_CTRL_D =          0x04
    TB_KEY_CTRL_E =          0x05
    TB_KEY_CTRL_F =          0x06
    TB_KEY_CTRL_G =          0x07
    TB_KEY_BACKSPACE =       0x08
    TB_KEY_CTRL_H =          0x08
    TB_KEY_TAB =             0x09
    TB_KEY_CTRL_I =          0x09
    TB_KEY_CTRL_J =          0x0A
    TB_KEY_CTRL_K =          0x0B
    TB_KEY_CTRL_L =          0x0C
    TB_KEY_ENTER =           0x0D
    TB_KEY_CTRL_M =          0x0D
    TB_KEY_CTRL_N =          0x0E
    TB_KEY_CTRL_O =          0x0F
    TB_KEY_CTRL_P =          0x10
    TB_KEY_CTRL_Q =          0x11
    TB_KEY_CTRL_R =          0x12
    TB_KEY_CTRL_S =          0x13
    TB_KEY_CTRL_T =          0x14
    TB_KEY_CTRL_U =          0x15
    TB_KEY_CTRL_V =          0x16
    TB_KEY_CTRL_W =          0x17
    TB_KEY_CTRL_X =          0x18
    TB_KEY_CTRL_Y =          0x19
    TB_KEY_CTRL_Z =          0x1A
    TB_KEY_ESC =             0x1B
    TB_KEY_CTRL_LSQ_BRACKET = 0x1B
    TB_KEY_CTRL_3 =          0x1B
    TB_KEY_CTRL_4 =          0x1C
    TB_KEY_CTRL_BACKSLASH =  0x1C
    TB_KEY_CTRL_5 =          0x1D
    TB_KEY_CTRL_RSQ_BRACKET = 0x1D
    TB_KEY_CTRL_6 =          0x1E
    TB_KEY_CTRL_7 =          0x1F
    TB_KEY_CTRL_SLASH =      0x1F
    TB_KEY_CTRL_UNDERSCORE =  0x1F
    TB_KEY_SPACE =           0x20
    TB_KEY_BACKSPACE2 =      0x7F
    TB_KEY_CTRL_8 =          0x7F

    TB_MOD_ALT = 0x01

    TB_DEFAULT = 0x00
    TB_BLACK   = 0x01
    TB_RED     = 0x02
    TB_GREEN   = 0x03
    TB_YELLOW  = 0x04
    TB_BLUE    = 0x05
    TB_MAGENTA = 0x06
    TB_CYAN    = 0x07
    TB_WHITE   = 0x08

    TB_BOLD      = 0x0100
    TB_UNDERLINE = 0x0200
    TB_REVERSE   = 0x0400

    TB_EVENT_KEY    = 1
    TB_EVENT_RESIZE = 2

    TB_EUNSUPPORTED_TERMINAL = -1
    TB_EFAILED_TO_OPEN_TTY   = -2
    TB_EPIPE_TRAP_ERROR      = -3

    TB_HIDE_CURSOR = -1

    TB_INPUT_CURRENT = 0
    TB_INPUT_ESC     = 1
    TB_INPUT_ALT     = 2

    TB_OUTPUT_CURRENT   = 0
    TB_OUTPUT_NORMAL    = 1
    TB_OUTPUT_256       = 2
    TB_OUTPUT_216       = 3
    TB_OUTPUT_GRAYSCALE = 4

    # The tb_cell struct as returned by libtermbox
    class Cell < FFI::Struct
      layout :ch, :int,
             :fg, :uint16,
             :bg, :uint16
    end

    # The tb_event struct as returned by libtermbox
    class Event < FFI::Struct
      layout :type, :uint8,
             :mod,  :uint8,
             :key,  :uint16,
             :ch,   :uint32,
             :w,    :int32,
             :h,    :int32
    end

    Pos = Struct.new(:x, :y) do
      def initialize(pos = {})
        self.x = pos[:x]
        self.y = pos[:y]
      end
    end

    Chr = Struct.new(:ch, :fg, :bg, :x, :y) do
      def initialize(chr = {})
        self.ch = chr[:ch].class == String ? chr[:ch].unpack('H*').first.to_i(16) : chr[:ch]
        self.fg = chr[:fg] || Termbox::TB_WHITE
        self.bg = chr[:bg] || Termbox::TB_DEFAULT
        self.x  = chr[:x]
        self.y  = chr[:y]
      end
    end

    attach_function :tb_init, [], :int
    attach_function :tb_shutdown, [], :void
    attach_function :tb_width, [], :int
    attach_function :tb_height, [], :int
    attach_function :tb_clear, [], :void
    attach_function :tb_set_clear_attributes, [:uint16, :uint16], :void
    attach_function :tb_present, [], :void
    attach_function :tb_set_cursor, [:int, :int], :void
    attach_function :tb_put_cell, [:int, :int, Cell], :void
    attach_function :tb_change_cell, [:int, :int, :uint32, :uint16, :uint16], :void
    attach_function :tb_cell_buffer, [], Cell
    attach_function :tb_select_input_mode, [:int], :int
    attach_function :tb_select_output_mode, [:int], :int
    attach_function :tb_peek_event, [Event, :int], :int
    attach_function :tb_poll_event, [Event], :int

    class << self
      alias_method :init,      :tb_init
      alias_method :shutdown,  :tb_shutdown
      alias_method :width,     :tb_width
      alias_method :height,    :tb_height
      alias_method :clear,     :tb_clear
      alias_method :set_clear_attributes, :tb_set_clear_attributes
      alias_method :present,   :tb_present
      alias_method :cell_buffer, :tb_cell_buffer
      alias_method :select_input_mode, :tb_select_input_mode
      alias_method :select_output_mode, :tb_select_output_mode

      def set_cursor(pos, y = nil)
        if pos.class == Pos
          Termbox.tb_set_cursor(pos.x, pos.y)
        elsif pos.class == Hash
          Termbox.tb_set_cursor(pos[:x], pos[:y])
        else
          Termbox.tb_set_cursor(pos, y)
        end
      end

      def put_cell(chr)
        cell = Cell.new
        cell[:ch] = chr.ch
        cell[:fg] = chr.fg
        cell[:bg] = chr.bg
        Termbox.tb_put_cell(chr.x, chr.y, cell)
      end

      def change_cell(chr)
        return if chr.ch.nil?
        Termbox.tb_change_cell(chr.x, chr.y, chr.ch, chr.fg, chr.bg)
      end

      def peek_event(timeout, &block)
        evt = Termbox::Event.new

        block.call(evt) while Termbox.tb_peek_event(evt, timeout)
      end

      def poll_event(&block)
        evt = Termbox::Event.new

        block.call(evt) while Termbox.tb_poll_event(evt)
      end
    end
  end
end
