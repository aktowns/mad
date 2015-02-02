require 'mad/terminal'

module Mad
  # represents the cursor on a buffer
  class Cursor
    attr_reader :pos

    def initialize
      @pos = Terminal::Pos.new(x: 0, y: 0)
    end

    def set(x, y)
      @pos.x = x
      @pos.y = y
    end

    def update
      Terminal.set_cursor(@pos)
    end

    def down
      @pos.y += 1
    end

    def up
      @pos.y -= 1 if @pos.y > 0
    end

    def right
      @pos.x += 1
    end

    def left
      @pos.x -= 1 if @pos.x > 0
    end
  end
end
