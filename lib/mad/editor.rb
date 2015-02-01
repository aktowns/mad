require 'mad/termbox'
require 'mad/buffer'
require 'mad/theme'
require 'mad/log'
require 'mad/cursor'
require 'mad/language'

module Mad
  class NotImplemented < Exception; end
  
  # The main Editor class, handles keyboard and rendering
  class Editor
    def initialize(filename, language = :unknown)
      language = Language.infer_language(filename) if language == :unknown

      # if we can't infer, dropback to plaintext
      language = :plaintext if language == :unknown

      lexer = Language.available_lexers[language]

      Termbox.init
      Termbox.select_output_mode(Termbox::TB_OUTPUT_256)
      @gutter_size = 5
      @cursor = Cursor.new
      @cursor.pos.x = @gutter_size
      @buffer = Buffer.from_file(filename, lexer)
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

    def cursor_x_reset
      @cursor.pos.x = @gutter_size
    end

    def cursor_y_reset
      @cursor.pos.y = 0
    end

    def cursor_reset
      cursor_x_reset
      cursor_y_reset
    end

    def handle_esc
      Log.common.info(@buffer.to_s)
      exit
    end

    def handle_arrow_down
      return if (@cursor.pos.y + @buffer.offset_y) >= @buffer.lines

      next_line_width = @gutter_size + @buffer[@cursor.pos.y + 1].width
      @cursor.pos.x = next_line_width if @cursor.pos.x >= next_line_width

      if @cursor.pos.y >= (Termbox.height - 1)
        @buffer.offset_y += 1
      else
        @cursor.down
      end
    end

    def handle_arrow_up
      previous_line_width = @gutter_size + @buffer[@cursor.pos.y - 1].width
      @cursor.pos.x = previous_line_width if @cursor.pos.x >= previous_line_width

      if @cursor.pos.y == 0 && @buffer.offset_y > 0
        @buffer.offset_y -= 1
      elsif @cursor.pos.y > 0
        @cursor.up
      end
    end

    def handle_arrow_right
      @cursor.right if @cursor.pos.x < @gutter_size + @buffer[@cursor.pos.y].width
    end

    def handle_arrow_left
      @cursor.left if @cursor.pos.x > @gutter_size
    end

    def handle_key_end
      @cursor.pos.x = @gutter_size + @buffer[@cursor.pos.y].width
    end

    def handle_key_home
      cursor_x_reset
    end

    def handle_key_pageup
      if @cursor.pos.y != 0
        cursor_reset
      elsif @buffer.offset_y > 0
        if @buffer.offset_y > Termbox.height
          @buffer.offset_y -= Termbox.height
        else
          @buffer.offset_y = 0
        end
      end
    end

    def handle_key_pagedown
      return if (@cursor.pos.y + @buffer.offset_y) >= @buffer.lines

      if (@cursor.pos.y + @buffer.offset_y + Termbox.height) < @buffer.lines
        @buffer.offset_y += Termbox.height
        cursor_y_reset
      else
        @cursor.pos.y += (@buffer.lines - @buffer.offset_y)
      end
      cursor_x_reset
    end

    def handle_key_enter_middle_of_line(cursor_x)
      bfr = @buffer[@cursor.pos.y]
      prev = bfr[0..(cursor_x - 1)]
      cut = bfr[cursor_x..-1]

      @buffer.delete_line(@cursor.pos.y)
      @buffer.insert_line(@cursor.pos.y, cut)
      @buffer.insert_line(@cursor.pos.y, prev)
    end

    def handle_key_enter
      cursor_x = @cursor.pos.x - @gutter_size

      if cursor_x == 0
        @buffer.insert_line(@cursor.pos.y)
      elsif cursor_x >= @buffer[@cursor.pos.y].width
        @buffer.insert_line(@cursor.pos.y + 1)
      else
        handle_key_enter_middle_of_line(cursor_x)
      end
      cursor_x_reset
      @cursor.down
    end

    def handle_key_backspace_start_of_line
      new_pos = @buffer[@cursor.pos.y - 1].width + @gutter_size
      @buffer[@cursor.pos.y - 1].append(@buffer[@cursor.pos.y])
      @buffer.delete_line(@cursor.pos.y)
      @cursor.up
      @cursor.pos.x = new_pos
    end

    def handle_key_backspace
      if @cursor.pos.x <= @gutter_size
        handle_key_backspace_start_of_line
      else
        @buffer[@cursor.pos.y].delete_at(@cursor.pos.x - @gutter_size - 1)
        @cursor.left
      end

      @buffer.update_highlighter
    end

    def handle_key_tab
      @buffer[@cursor.pos.y].insert_at(@cursor.pos.x - @gutter_size, ' ')
      2.times { @cursor.right }
      update
    end

    def handle_ascii_key(key)
      @buffer[@cursor.pos.y].insert_at(@cursor.pos.x - @gutter_size, key)
      @cursor.right
      @buffer.update_highlighter
    end

    def keyboard_handler
      Termbox.poll_event do |evt|
        if evt[:type] == Termbox::TB_EVENT_KEY
          case evt[:key]
          when Termbox::TB_KEY_ESC          then handle_esc
          when Termbox::TB_KEY_ARROW_DOWN   then handle_arrow_down
          when Termbox::TB_KEY_ARROW_UP     then handle_arrow_up
          when Termbox::TB_KEY_ARROW_RIGHT  then handle_arrow_right
          when Termbox::TB_KEY_ARROW_LEFT   then handle_arrow_left
          when Termbox::TB_KEY_END          then handle_key_end
          when Termbox::TB_KEY_HOME         then handle_key_home
          when Termbox::TB_KEY_PGUP         then handle_key_pageup
          when Termbox::TB_KEY_PGDN         then handle_key_pagedown
          when Termbox::TB_KEY_ENTER        then handle_key_enter
          when Termbox::TB_KEY_BACKSPACE,
               Termbox::TB_KEY_BACKSPACE2,
               Termbox::TB_KEY_DELETE       then handle_key_backspace
          when Termbox::TB_KEY_TAB          then handle_key_tab
          else
            if evt[:ch].chr.ascii_only?
              handle_ascii_key(evt[:ch].chr)
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
