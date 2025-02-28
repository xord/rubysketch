module RubySketch


  # Shape class for physics calculations.
  #
  class Shape

    include Xot::Inspectable

    # @private
    def initialize(shape)
      @shape = shape or raise ArgumentError
      @shape.instance_variable_set :@owner__, self
    end

    # Returns the width of the shape.
    #
    # @return [Numeric] width
    #
    def width()
      @shape.width
    end

    # Returns the height of the shape.
    #
    # @return [Numeric] height
    #
    def height()
      @shape.height
    end

    alias w width
    alias h height

    # Set this shape as a sensor object.
    # Sensor object receives contact events, but no collisions.
    #
    # @return [Boolean] sensor or not
    #
    def sensor=(state)
      @shape.sensor = state
    end

    # Returns whether the shape is a sensor or not.
    #
    # @return [Boolean] sensor or not
    #
    def sensor?()
      @shape.sensor?
    end

    # Defines contact block.
    #
    # @example Score increases when the shape touches a coin
    #  shape.contact do |o|
    #    score += 1 if o.coin?
    #  end
    #
    # @return [nil] nil
    #
    def contact(&block)
      @shape.contact_begin do |other|
        block.call other.instance_variable_get :@owner__ if block
      end
      nil
    end

    # Defines contact_end block.
    #
    # @example Call jumping() when the shape leaves the ground sprite
    #  shape.contact_end do |o|
    #    jumping if o == groundSprite
    #  end
    #
    # @return [nil] nil
    #
    def contact_end(&block)
      @shape.contact_end do |other|
        block.call other.instance_variable_get :@owner__ if block
      end
      nil
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

    # Initialize circle object.
    #
    # @param [Numeric] x    x of the circle shape position
    # @param [Numeric] y    y of the circle shape position
    # @param [Numeric] size width and height of the circle shape
    #
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
