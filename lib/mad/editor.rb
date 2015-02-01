require_relative 'termbox'
require_relative 'buffer'
require_relative 'theme'
require_relative 'log'
require_relative 'cursor'

module Mad
  class NotImplemented < Exception; end

  # The main Editor class, handles keyboard and rendering
  class Editor
    def initialize(filename)
      Termbox.init
      Termbox.select_output_mode(Termbox::TB_OUTPUT_256)
      @gutter_size = 5
      @cursor = Cursor.new
      @cursor.pos.x = @gutter_size
      @buffer = Buffer.from_file(filename)
      update
    end

    def update
      Termbox.clear
      @buffer.each do |line, y|
        line.each do |char, x|
          colour = Theme.get_colour(@buffer.highlight_at(y, x))
          Termbox.change_cell(Termbox::Chr.new(x: x + @gutter_size, y: y, ch: char, fg: colour))
        end
      end
      update_linums
      Termbox.present
    end

    def update_linums
      ((@buffer.offset_y + 1)..(@buffer.offset_y + Termbox.height + 1)).to_a.each_with_index do |i, y|
        sprintf('%-03d|', i).split('').each_with_index do |ch, x|
          if (i <= @buffer.lines + 1)
            Termbox.change_cell(Termbox::Chr.new(x: x, y: y, ch: ch, fg: Termbox::TB_YELLOW, bg: Termbox::TB_DEFAULT))
          end
        end
      end
    end

    def shutdown
      Termbox.shutdown
    end

    def cursor_x_reset
      @cursor.pos.x = @gutter_size
    end

    def cursor_y_reset
      @cursor.pos.y = 0
    end

    def keyboard_handler
      Termbox.poll_event do |evt|
        if evt[:type] == Termbox::TB_EVENT_KEY
          case evt[:key]
          when Termbox::TB_KEY_ESC
            Log.common.info(@buffer.to_s)
            break
          when Termbox::TB_KEY_ARROW_DOWN
            if (@cursor.pos.y + @buffer.offset_y) < @buffer.lines
              if @cursor.pos.x >= @gutter_size + @buffer[@cursor.pos.y + 1].width
                @cursor.pos.x = @gutter_size + @buffer[@cursor.pos.y + 1].width
              end

              if @cursor.pos.y >= (Termbox.height - 1)
                @buffer.offset_y += 1
                update
              else
                @cursor.down
              end
            end
          when Termbox::TB_KEY_ARROW_UP
            if @cursor.pos.x >= @gutter_size + @buffer[@cursor.pos.y - 1].width
              @cursor.pos.x = @gutter_size + @buffer[@cursor.pos.y - 1].width
            end

            if @cursor.pos.y == 0 && @buffer.offset_y > 0
              @buffer.offset_y -= 1
            elsif @cursor.pos.y > 0
              @cursor.up
            end
          when Termbox::TB_KEY_ARROW_RIGHT
            @cursor.right if @cursor.pos.x < @gutter_size + @buffer[@cursor.pos.y].width
          when Termbox::TB_KEY_ARROW_LEFT
            @cursor.left if @cursor.pos.x > @gutter_size
          when Termbox::TB_KEY_END
            @cursor.pos.x = @gutter_size + @buffer[@cursor.pos.y].width
          when Termbox::TB_KEY_HOME
            cursor_x_reset
          when Termbox::TB_KEY_PGUP
            if @cursor.pos.y != 0
              cursor_y_reset
              cursor_x_reset
            elsif @buffer.offset_y > 0
              if @buffer.offset_y > Termbox.height
                @buffer.offset_y -= Termbox.height
              else
                @buffer.offset_y = 0
              end
            end
          when Termbox::TB_KEY_PGDN
            cursor_x_reset
            if (@cursor.pos.y + @buffer.offset_y) != @buffer.lines
              if (@cursor.pos.y + @buffer.offset_y + Termbox.height) < @buffer.lines
                @buffer.offset_y += Termbox.height
                cursor_y_reset
              else
                @cursor.pos.y += (@buffer.lines - @buffer.offset_y)
              end
            end
          when Termbox::TB_KEY_ENTER
            if (@cursor.pos.x - @gutter_size) == 0
              cursor_x_reset
              @buffer.insert_line(@cursor.pos.y)
              @cursor.down
            elsif (@cursor.pos.x - @gutter_size) >= @buffer[@cursor.pos.y].width
              cursor_x_reset
              @buffer.insert_line(@cursor.pos.y + 1)
              @cursor.down
            else
              off = (@cursor.pos.x - @gutter_size)
              bfr = @buffer[@cursor.pos.y]
              prev = bfr[0..(off - 1)]
              cut = bfr[off..-1]
              cursor_x_reset
              @buffer.delete_line(@cursor.pos.y)
              @buffer.insert_line(@cursor.pos.y, cut)
              @buffer.insert_line(@cursor.pos.y, prev)
              @cursor.down
            end
          when Termbox::TB_KEY_BACKSPACE, Termbox::TB_KEY_BACKSPACE2, Termbox::TB_KEY_DELETE
            if @cursor.pos.x <= @gutter_size
              new_pos = @buffer[@cursor.pos.y - 1].width + @gutter_size
              @buffer[@cursor.pos.y - 1].append(@buffer[@cursor.pos.y])
              @buffer.delete_line(@cursor.pos.y)
              @buffer.update_highlighter
              @cursor.up
              @cursor.pos.x = new_pos
            else
              @buffer[@cursor.pos.y].delete_at(@cursor.pos.x - @gutter_size - 1)
              @buffer.update_highlighter
              @cursor.left
            end
          when Termbox::TB_KEY_TAB
            @buffer[@cursor.pos.y].insert_at(@cursor.pos.x - @gutter_size, '  ')
            2.times { @cursor.right }
            update
          else
            if evt[:ch].chr.ascii_only?
              @buffer[@cursor.pos.y].insert_at(@cursor.pos.x - @gutter_size, evt[:ch].chr)
              @cursor.right
              @buffer.update_highlighter
            else
              fail(NotImplemented, "#{evt[:key].inspect} #{evt[:ch].inspect}")
            end
          end
          @cursor.update
          update
        end
      end
    end
  end
end
