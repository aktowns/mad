require 'spec_helper'

module Mad
  describe Theme do
    it 'sets a colour, given a token' do
      expect(Theme.get_colour(:keyword)).to eq(Theme::BLUE)
    end

    it 'returns :text for nil' do
      expect(Theme.get_colour(nil)).to eq(Theme::CYAN)
    end

    it 'raises an exception for an unknown token' do
      expect { Theme.get_colour(:bob) }.to raise_error(ThemeKeywordUnknown, 'bob')
    end
  end
end
