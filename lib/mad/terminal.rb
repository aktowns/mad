require 'termbox'

module Mad
  # Low level FFI Bindings to libtermbox
  module Terminal
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

    class << self
      include Termbox

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
