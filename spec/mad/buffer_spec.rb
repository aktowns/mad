require 'spec_helper'

EXAMPLE_RUBY = <<-RUBY
require 'json'

def load_json_from_filename(filename)
  JSON.parse(IO.read(filename))
end

load_json_from_filename "hello_world.json"
RUBY

module Mad
  describe Buffer do
    let :file_contents do
      stream = StringIO.new
      stream.puts EXAMPLE_RUBY
      stream.pos = 0
      stream
    end

    before(:each) do
      @buffer = Buffer.from_stream(file_contents)
    end

    it 'can read from a stream' do
      expect(@buffer.to_s).to eq(file_contents.string)
    end

    it 'returns the correct line length' do
      length = file_contents.string.split("\n").length
      expect(@buffer.lines).to eq(length)
    end

    it 'returns the correct character at a position' do
      expect(@buffer.char_at(2, 2)).to eq('f')
      expect(@buffer.char_at(0, 0)).to eq('r')
      expect(@buffer.char_at(6, 41)).to eq('"')
    end

    it 'can highlight source code' do
      @buffer.update_highlighter
      expect(@buffer.highlight_at(2, 2)).to eq(:keyword)
      expect(@buffer.highlight_at(0, 0)).to eq(:name_builtin)
      expect(@buffer.highlight_at(6, 41)).to eq(:literal_string_double)
    end

    it 'ignores highlights it does not understand yet' do
      expect(@buffer.highlight_at(1000, 1000)).to eq(:text)
    end

    it 'deletes a line at a given index' do
      @buffer.delete_line(0)

      expect(@buffer.char_at(0, 0)).not_to eq('r')
      expect(@buffer.highlight_at(0, 0)).to eq(:text)

      @buffer.delete_line(0)

      expect(@buffer.char_at(0, 0)).to eq('d')
      expect(@buffer.highlight_at(0, 0)).to eq(:keyword)
    end

    it 'inserts a line at a given index' do
      @buffer.insert_line(0, ['#', 'w', 'o', 'o'])

      expect(@buffer.char_at(0, 0)).to eq('#')
      expect(@buffer.highlight_at(0, 0)).to eq(:comment_single)

      expect(@buffer.char_at(1, 0)).to eq('r')
      expect(@buffer.highlight_at(1, 0)).to eq(:name_builtin)
    end
  end
end
