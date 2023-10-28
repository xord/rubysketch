module RubySketch


  class Shape

    include Xot::Inspectable

    # @private
    def initialize(shape)
      @shape = shape or raise ArgumentError
      @shape.instance_variable_set :@owner__, self
    end

    def sensor=(state)
      @shape.sensor = state
    end

    def sensor?()
      @shape.sensor?
    end

    def contact(&block)
      return unless block
      @shape.contact_begin do |other|
        block.call other.instance_variable_get :@owner__
      end
    end

    def contact_end(&block)
      return unless block
      @shape.contact_end do |other|
        block.call other.instance_variable_get :@owner__
      end
    end

    # @private
    def getInternal__()
      @shape
    end

    # @private
    def draw__(context, x, y, width, height)
      raise NotImplementedError
    end

  end# Shape


  # Circle shape object.
  #
  class Circle < Shape

    def initialize(x, y, size)
      super Reflex::EllipseShape.new(frame: [x, y, size, size])
    end

    # @private
    def draw__(c, x, y, w, h)
      f = @shape.frame
      c.pushStyle do
        c.ellipseMode CORNER
        c.ellipse x + f.x, y + f.y, f.w, f.h
      end
    end

  end# Circle


end# RubySketch
