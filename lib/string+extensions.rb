class String
  attr_accessor :fg, :bg

  def to_hex
    self.unpack('H*').to_i(16)
  end
end
