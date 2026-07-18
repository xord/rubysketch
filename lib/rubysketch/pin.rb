module RubySketch


  # A pin fastened at a point on a sprite.
  # Creating a constraint between sprites starts from a pin.
  #
  class Pin

    # @private
    def initialize(sprite, x = nil, y = nil, pin__: nil)
      if pin__
        @sprite__ = pin__.view&.sprite
        @pin__    = pin__
      else
        @sprite__ = sprite
        @pin__    = x ? sprite.getInternal__.pin(x, y) : sprite.getInternal__.pin
      end
    end

    # Creates a constraint that makes the pin and the target point coincide.
    #
    # @param [Sprite, Pin, Vector, Array<Numeric>, nil] target
    #  the center of a sprite, a pin, or a point in the world.
    #  snaps to the world when target is omitted
    #
    # @return [SnapConstraint] a new constraint
    #
    def snap(*args, **options, &block)
      create__ SnapConstraint, @pin__.snap(*unwrap__(args)), options, block
    end

    # Creates a constraint that keeps the distance to the target point.
    #
    # @param [Sprite, Pin, Vector, Array<Numeric>, nil] target
    #  the center of a sprite, a pin, or a point in the world.
    #  links to the world when target is omitted
    #
    # @return [LinkConstraint] a new constraint
    #
    def link(*args, **options, &block)
      create__ LinkConstraint, @pin__.link(*unwrap__(args)), options, block
    end

    # Creates a constraint that makes the pin ride on the target like a
    # wheel: it slides along an axis for the suspension and spins freely.
    #
    # @param [Sprite, Pin, Vector, Array<Numeric>, nil] target
    #  the center of a sprite, a pin, or a point in the world.
    #  rides on the world when target is omitted
    #
    # @return [WheelConstraint] a new constraint
    #
    def wheel(*args, **options, &block)
      create__ WheelConstraint, @pin__.wheel(*unwrap__(args)), options, block
    end

    # Creates a constraint that moves the pin toward the target every frame.
    #
    # @param [Sprite, Pin, Vector, Array<Numeric>, nil] target
    #  the center of a sprite, a pin, or a point in the world.
    #  chases nothing when target is omitted
    #
    # @return [ChaseConstraint] a new constraint
    #
    def chase(*args, **options, &block)
      create__ ChaseConstraint, @pin__.chase(*unwrap__(args)), options, block
    end

    # Returns the sprite the pin is fastened to.
    #
    # @return [Sprite, nil] nil for a pin in the world
    #
    def sprite()
      @sprite__
    end

    # Returns the position of the pin.
    #
    # @return [Vector, nil] sprite-local position, or nil for the center
    #
    def position()
      @pin__.position&.toVector
    end

    alias pos position

    # @private
    def getInternal__()
      @pin__
    end

    private

    def create__(klass, constraint, options, block)
      klass.new(constraint).tap do |c|
        c.set options unless options.empty?
        Xot::BlockUtil.instance_eval_or_block_call c, &block if block
      end
    end

    def unwrap__(args)
      args.map {|arg| RubySketch.unwrap__ arg}
    end

  end# Pin


end# RubySketch
