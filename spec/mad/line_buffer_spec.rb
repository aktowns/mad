require 'spec_helper'

module Mad
  describe LineBuffer do
    let(:contents) { "Hello world!".split('') }

    before(:each) do
      @line_buffer = LineBuffer.new(contents)
    end

    it 'returns line contents as a string' do
      expect(@line_buffer.to_s).to eq(contents.join(''))
    end

    it 'returns line contents as an array' do
      expect(@line_buffer.to_a).to eq(contents)
    end

    it 'returns the correct line width' do
      expect(@line_buffer.width).to eq(contents.length)
    end

    it 'inserts a character at the given index' do
      @line_buffer.insert_at(1, 'a')
      @line_buffer.insert_at(5, '3')

      expect(@line_buffer[1]).to eq('a')
      expect(@line_buffer[2]).to eq('e')
      expect(@line_buffer[5]).to eq('3')

      expect(@line_buffer.to_s).to eq('Haell3o world!')
    end

    it 'overwrites a character a the given index' do
      @line_buffer[1] = 'a'

      expect(@line_buffer[0]).to eq('H')
      expect(@line_buffer[1]).to eq('a')
      expect(@line_buffer[2]).to eq('l')

      expect(@line_buffer.to_s).to eq('Hallo world!')
    end

    it 'deletes a character at the given index' do
      @line_buffer.delete_at(1)
      @line_buffer.delete_at(3)

      expect(@line_buffer[0]).to eq('H')
      expect(@line_buffer[1]).to eq('l')
      expect(@line_buffer[3]).to eq(' ')

      expect(@line_buffer.to_s).to eq('Hll world!')
    end

    it 'prepends to a line' do
      @line_buffer.prepend(['O', 'h', ' '])

      expect(@line_buffer[0]).to eq('O')
      expect(@line_buffer[3]).to eq('H')

      expect(@line_buffer.to_s).to eq('Oh Hello world!')
    end

    it 'appends to a line' do
      @line_buffer.append([' ', ':', ')'])

      expect(@line_buffer[0]).to eq('H')
      expect(@line_buffer[12]).to eq(' ')
      expect(@line_buffer[14]).to eq(')')

      expect(@line_buffer.to_s).to eq('Hello world! :)')
    end

    it 'deletes a range' do
      @line_buffer.delete_range(0..5)

      expect(@line_buffer.to_s).to eq('world!')
    end
  end
end
