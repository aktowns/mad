require 'rouge'

require 'mad/line_buffer'
require 'mad/formatter'
require 'mad/log'

module Mad
  class HighlighterUnknownSegment < Exception; end
  class LineInsertOutOfBounds < Exception; end

  # Represents a set of Linebuffers, a page.
  class Buffer
    # Current buffer offset from the top (ie how for down we're scrolled)
    attr_accessor :offset_y, :lexer

    def initialize(lexer)
      @lexer = lexer
      @offset_y = 0
      @lines = []
    end

    # Return a {Mad::LineBuffer LineBuffer} for the line at the given index, return an empty linebuffer
    # if there is nothing at that index.
    #
    # @param index [Fixnum] the index for the line
    # @return [LineBuffer] the linebuffer at index
    def [](index)
      # TODO: we probably should return nil or raise an error here.
      @lines[index + @offset_y] || LineBuffer.new #= LineBuffer.new
    end

    # Overwrite the {Mad::LineBuffer LineBuffer} at index
    #
    # @param index [Fixnum] the index of the line to overwrite
    # @param buffer [LineBuffer] the buffer to overwrite it with
    # @return [void]
    def []=(index, buffer)
      @lines[index + @offset_y] = buffer
    end

    # Insert a new line at index, throws a {Mad::LineInsertOutOfBounds} exception if the index is higher
    # than the current amount of lines
    #
    # @note Updates the highlighter (costly) see {#update_highlighter #update_highlighter}
    # @param index [Fixnum] the index to insert at
    # @param item [Array<String>] array of characters to insert
    # @return [void]
    def insert_line(index, item = [])
      fail(LineInsertOutOfBounds, "#{num} is higher then #{lines}") if index > @lines.length
      @lines.insert(index + @offset_y, LineBuffer.new(item))
      update_highlighter
    end

    # Delete the line at index
    #
    # @note Updates the highlighter (costly) see {#update_highlighter #update_highlighter}
    # @param index [Fixnum] the index to delete at
    # @return [void]
    def delete_line(index)
      @lines.delete_at(index + @offset_y)
      update_highlighter
    end

    # The amount of lines the buffer encompases
    #
    # @return [Fixnum] line count
    def lines
      @lines.length
    end

    # Convert the buffer to its string representation
    #
    # @return [String]
    def to_s
      @lines.map(&:to_s).join("\n") + "\n"
    end

    # Convert the buffer to its array representation
    #
    # @return [Array<Array<String>>]
    def to_a
      @lines.map(&:to_a)
    end

    # Iterate through each line inside the buffer
    #
    # @yield [LineBuffer] current line
    # @return [void]
    def each(&block)
      @lines[@offset_y..-1].each_with_index(&block)
    end

    # Iterate through each character inside the buffer
    #
    # @yield [String] current char
    # @return [void]
    def each_char(&block)
      @lines[@offset_y..-1].map(&:to_a).flatten.each_with_index(&block)
    end

    # Return the character at x,y
    #
    # @param y [Fixnum] y index
    # @param x [Fixnum] x index
    # @return [String]
    def char_at(y, x)
      self[@offset_y + y][x]
    end

    # Update the current highlighter lookup table
    # @note This method is costly, it requires relexing the current file and generating new tokens.
    #
    # @return [void]
    def update_highlighter
      formatter = Formatter.new
      lexer ||= @lexer.new

      formatter.format(lexer.lex(to_s))

      Log.specific('prelex.log').debug(to_s) if Mad.debug?
      Log.common.debug(formatter.toks.inspect)

      @highlighter_tokens = formatter.toks
    end

    # The current highlight token for the item at y, x if the token is unknown returns :text
    #
    # @param y [Fixnum]
    # @param x [Fixnum]
    # @return [Symbol] the token
    def highlight_at(y, x)
      highlight_at!(y, x)

    rescue HighlighterUnknownSegment
      :text
    end

    # The current highlight token for the item at y, x if the token is unknown throws
    # a {Mad::HighlighterUnknownSegment HighlighterUnknownSegment} exception.
    #
    # @param y [Fixnum]
    # @param x [Fixnum]
    # @return [Symbol] the token
    def highlight_at!(y, x)
      update_highlighter if @highlighter_tokens.nil?

      fail(HighlighterUnknownSegment, "line: #{y}") if @highlighter_tokens[@offset_y + y].nil?
      fail(HighlighterUnknownSegment, "line: #{y} char: #{x}") if @highlighter_tokens[@offset_y + y][x].nil?

      @highlighter_tokens[@offset_y + y][x]
    end

    # Read in buffer contents from the given filename
    #
    # @param fn [String] the filename
    # @return [Buffer] output buffer
    def self.from_file(fn, lexer)
      File.open(fn, 'r') { |str| Buffer.from_stream(str, lexer) }
    end

    # Read in buffer contents from the given stream
    #
    # @param stream [IOStream] the stream
    # @return [Buffer] output buffer
    def self.from_stream(stream, lexer)
      bfr = Buffer.new(lexer)
      stream.read.split("\n").each_with_index do |line, i|
        bfr[i] = LineBuffer.new(line.split(''))
      end
      bfr
    end
  end
end
