require 'rouge'

require 'mad/line_buffer'
require 'mad/formatter'
require 'mad/log'

module Mad
  class HighlighterUnknownSegment < Exception; end
  class LineInsertOutOfBounds < Exception; end

  class Buffer
    attr_accessor :offset_y

    def initialize
      @offset_y = 0
      @lines = []
    end

    def [](y)
      @lines[y+@offset_y] || LineBuffer.new #= LineBuffer.new
    end

    def []=(y, x)
      @lines[y+@offset_y] = x
    end

    def insert_line(num, item=[])
      raise LineInsertOutOfBounds.new("#{num} is higher then #{lines}") if num > @lines.length
      @lines.insert(num+@offset_y, LineBuffer.new(item))
      update_highlighter
    end

    def delete_line(num)
      @lines.delete_at(num+@offset_y)
      update_highlighter
    end

    def lines
      @lines.length
    end

    def to_s
      @lines.map(&:to_s).join("\n")
    end

    def to_a
      @lines.map(&:to_a)
    end

    def each(&block)
      @lines[@offset_y..-1].each_with_index(&block)
    end

    def each_char(&block)
      @lines[@offset_y..-1].map(&:to_a).flatten.each_with_index(&block)
    end

    def char_at(y, x)
      self[@offset_y+y][x]
    end

    def update_highlighter
      formatter = Formatter.new
      lexer     = Rouge::Lexers::Ruby.new

      formatter.format(lexer.lex(to_s))

      Log.specific('prelex.log').debug(to_s) if Mad.debug?
      Log.common.debug(formatter.toks.inspect)

      @highlighter_tokens = formatter.toks
    end

    def highlight_at(y, x)
      begin
        highlight_at!(y, x)
      rescue HighlighterUnknownSegment
        :text
      end
    end

    def highlight_at!(y, x)
      update_highlighter if @highlighter_tokens.nil?

      raise HighlighterUnknownSegment.new("line: #{y}") if @highlighter_tokens[@offset_y+y].nil?
      raise HighlighterUnknownSegment.new("line: #{y} char: #{x}") if @highlighter_tokens[@offset_y+y][x].nil?

      @highlighter_tokens[@offset_y+y][x]
    end

    def self.from_file(fn)
      bfr = Buffer.new
      IO.read(fn).split("\n").each_with_index do |line, i|
        bfr[i] = LineBuffer.new(line.split(''))
      end
      bfr
    end
  end
end
