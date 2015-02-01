module Mad
  # Represents a singe line
  class LineBuffer
    attr_reader :chrs

    def initialize(chrs = [])
      @chrs = chrs
    end

    def [](x)
      @chrs[x] ||= nil
    end

    def []=(x, y)
      (x - @chrs.length).times { |i| @chrs.insert(i, ' ') } if @chrs.length < x
      @chrs[x] = y
    end

    def width
      @chrs.length
    end

    def to_s
      @chrs.join('')
    end

    def to_a
      @chrs
    end

    def delete_at(x)
      @chrs.delete_at(x)
    end

    def prepend(x)
      insert_at(0, x)
    end

    def append(x)
      insert_at(width, x)
    end

    def insert_at(i, x)
      if x.class == Array
        @chrs.insert(i, x).flatten!
      elsif x.class == LineBuffer
        @chrs.insert(i, x.chrs).flatten!
      else
        @chrs.insert(i, x)
      end
    end

    def delete_range(rng)
      rng.to_a.each_with_index { |x, i| delete_at(x - i) }
    end

    def each(&block)
      @chrs.each_with_index(&block)
    end
  end
end
