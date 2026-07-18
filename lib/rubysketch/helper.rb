# @private
class Rays::Point
  def toVector()
    Processing::Vector.new x, y, z
  end
end


module RubySketch

  # @private
  def self.unwrap__(arg)
    arg.respond_to?(:getInternal__) ? arg.getInternal__ : arg
  end

end# RubySketch
