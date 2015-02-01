require 'spec_helper'

# A crazy text editor written in ruby.
module Mad
  describe Cursor do
    before(:each) do
      @cursor = Cursor.new
    end

    it 'starts at 0,0' do
      expect(@cursor.pos.x).to eq(0)
      expect(@cursor.pos.y).to eq(0)
    end

    it 'can have a set position' do
      @cursor.set(10, 20)

      expect(@cursor.pos.x).to eq(10)
      expect(@cursor.pos.y).to eq(20)
    end

    it 'moves up' do
      @cursor.pos.y = 10
      @cursor.up

      expect(@cursor.pos.y).to eq(9)
    end

    it 'moves down' do
      @cursor.down

      expect(@cursor.pos.y).to eq(1)
    end

    it 'moves left' do
      @cursor.pos.x = 10
      @cursor.left

      expect(@cursor.pos.x).to eq(9)
    end

    it 'moves right' do
      @cursor.right

      expect(@cursor.pos.x).to eq(1)
    end

    it 'wont move into negative y axis' do
      @cursor.up

      expect(@cursor.pos.x).to eq(0)
    end

    it 'wont move into negative x axis' do
      @cursor.left

      expect(@cursor.pos.x).to eq(0)
    end
  end
end
