require_relative 'termbox'

class Cursor
  attr_reader :pos

  def initialize()
    @pos = Termbox::Pos.new(x: 0, y: 0)
  end

  def update
    Termbox.set_cursor(@pos)
  end

  def down
    @pos.y += 1
  end

  def up
    @pos.y -= 1
  end

  def right
    @pos.x += 1
  end

  def left
    @pos.x -= 1
  end
end
