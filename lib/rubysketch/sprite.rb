module RubySketch


  class Sprite

    attr_reader :position

    def initialize(x: 0, y: 0)
      @position = Processing::Vector.new x, y
    end

    alias pos position

    def x()
      pos.x
    end

    def y()
      pos.y
    end

  end# Sprite


end# RubySketch
