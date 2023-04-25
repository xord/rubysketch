module RubySketch


  # Sprite object.
  #
  class Sprite

    extend Forwardable

    # Initialize sprite object.
    #
    #
    # @overload new(image:) pos: [0, 0], size: [image.width, image.height]
    # @overload new(x, y, image:) pos: [x, y], size: [image.width, image.height]
    # @overload new(x, y, w, h) pos(x, y), size: [w, h]
    # @overload new(x, y, w, h, image:, offset:) pos: [x, y], size: [w, h], offset: [offset[0], offset[1]]
    #
    # @param x [Numeric] x of sprite position
    # @param y [Numeric] y of sprite position
    # @param w [Numeric] width of sprite
    # @param h [Numeric] height of sprite
    # @param image [Image] sprite image
    # @param offset [Array] offset [x, y] for sprite image
    # @param dynamic [Boolean] false(static) or true(dynamic) for physics
    #
    def initialize(
      x = 0, y = 0, w = nil, h = nil,
      image: nil, offset: nil, dynamic: false)

      w ||= (image&.width  || 0)
      h ||= (image&.height || 0)
      raise 'invalid size'  unless w >= 0 && h >= 0
      raise 'invalid image' if image && !image.getInternal__.is_a?(Rays::Image)

      @image__  = image
      @offset__ = offset ? Vector.new(*offset.to_a[0, 2]) : nil
      @view__   = View.new(
        self, x: x, y: y, w: w, h: h, back: :white, dynamic: dynamic)
    end

    # Returns the position of the sprite.
    #
    # @return [Vector] position
    #
    def position()
      @view__.position.toVector
    end

    # Sets the position of the sprite.
    #
    # @overload position=(ary)
    # @overload position=(vec)
    #
    # @param ary [Array] [x, y]
    # @param vec [Vector] position
    #
    # @return [Vector] position
    #
    def position=(arg)
      @view__.position = arg.is_a?(Vector) ? arg.getInternal__ : arg
      arg
    end

    # Returns the x-coordinate position of the sprite.
    #
    # @return [Numeric] sprite position x
    #
    def x()
      @view__.x
    end

    # Set the x-coordinate position of the sprite.
    #
    # @param n [Numeric] sprite position x
    #
    # @return [Numeric] sprite position x
    #
    def x=(n)
      @view__.x = n
      n
    end

    # Returns the y-coordinate position of the sprite.
    #
    # @return [Numeric] sprite position y
    #
    def y()
      @view__.y
    end

    # Set the y-coordinate position of the sprite.
    #
    # @param n [Numeric] sprite position y
    #
    # @return [Numeric] sprite position y
    #
    def y=(n)
      @view__.y = n
      n
    end

    alias pos  position
    alias pos= position=

    # Returns the size of the sprite.
    #
    # @return [Vector] size
    #
    def size()
      @view__.size.toVector
    end

    # Returns the width of the sprite.
    #
    # @return [Numeric] width
    #
    def width()
      @view__.width
    end

    # Returns the height of the sprite.
    #
    # @return [Numeric] height
    #
    def height()
      @view__.height
    end

    alias w width
    alias h height

    # Returns the velocity of the sprite.
    #
    # @return [Vector] velocity
    #
    def velocity()
      @view__.velocity.toVector
    end

    # Sets the velocity of the sprite.
    #
    # #overload velocity=(ary)
    # #overload velocity=(vec)
    #
    # @param ary [Array] [vx, vy]
    # @param vec [Vector] velocity
    #
    # @return [Vector] velocity
    #
    def velocity=(arg)
      @view__.velocity = arg.is_a?(Vector) ? arg.getInternal__ : arg
      arg
    end

    # Returns the x-axis velocity of the sprite.
    #
    # @return [Numeric] velocity.x
    #
    def vx()
      @view__.velocity.x
    end

    # Sets the x-axis velocity of the sprite.
    #
    # @param n [Numeric] x-axis velocity
    #
    # @return [Numeric] velocity.x
    #
    def vx=(n)
      @view__.velocity = @view__.velocity.tap {|v| v.x = n}
      n
    end

    # Returns the y-axis velocity of the sprite.
    #
    # @return [Numeric] velocity.y
    #
    def vy()
      @view__.velocity.y
    end

    # Sets the y-axis velocity of the sprite.
    #
    # @param n [Numeric] y-axis velocity
    #
    # @return [Numeric] velocity.y
    #
    def vy=(n)
      @view__.velocity = @view__.velocity.tap {|v| v.y = n}
      n
    end

    alias vel  velocity
    alias vel= velocity=

    # Returns the image of the sprite.
    #
    # @return [Image] sprite image
    #
    def image()
      @image__
    end

    # Returns the offset of the sprite image.
    #
    # @return [Vector] offset of the sprite image
    #
    def offset()
      @offset__
    end

    # Returns whether the sprite is movable by the physics engine.
    #
    # @return [Boolean] true if dynamic
    #
    def dynamic?()
      @view__.dynamic?
    end

    # Sets whether the sprite is movable by the physics engine.
    #
    # @param bool [Boolean] movable or not
    #
    # @return [Boolean] true if dynamic
    #
    def dynamic=(bool)
      @view__.dynamic = bool
      bool
    end

    # Returns the density of the sprite.
    #
    # @return [Numeric] density
    #
    def density()
      @view__.density
    end

    # Sets the density of the sprite.
    #
    # @param n [Numeric] density
    #
    # @return [Numeric] density
    #
    def density=(n)
      @view__.density = n
      n
    end

    # Returns the friction of the sprite.
    #
    # @return [Numeric] friction
    #
    def friction()
      @view__.friction
    end

    # Sets the friction of the sprite.
    #
    # @param n [Numeric] friction
    #
    # @return [Numeric] friction
    #
    def friction=(n)
      @view__.friction = n
      n
    end

    # Returns the restitution of the sprite.
    #
    # @return [Numeric] restitution
    #
    def restitution()
      @view__.restitution
    end

    # Sets the restitution of the sprite.
    #
    # @param n [Numeric] restitution
    #
    # @return [Numeric] restitution
    #
    def restitution=(n)
      @view__.restitution = n
      n
    end

    alias dens  density
    alias dens= density=
    alias fric  friction
    alias fric= friction=
    alias rest  restitution
    alias rest= restitution=

    # Defines update block.
    #
    # @example vx is updated every frame
    #  sprite.update do
    #    self.vx *= 0.9
    #  end
    #
    # @return [nil] nil
    #
    def update(&block)
      @view__.update = block
    end

    # Defines contact block.
    #
    # @example Score increases when the player sprite touches a coin
    #  playerSprite.contact do |o|
    #    score += 1 if o.coin?
    #  end
    #
    # @return [nil] nil
    #
    def contact(&block)
      @view__.contact = block
    end

    # Defines contact? block.
    #
    # @example only collide with an enemy
    #  playerSprite.contact? do |o|
    #    o.enemy?
    #  end
    #
    # @return [nil] nil
    #
    def contact?(&block)
      @view__.will_contact = block
    end

    # @private
    def getInternal__()
      @view__
    end

    # @private
    class View < Reflex::View
      attr_accessor :update, :contact, :will_contact
      attr_reader :sprite

      def initialize(sprite, *a, **k, &b)
        @sprite = sprite
        super(*a, **k, &b)
      end

      def on_update(e)
        @update.call if @update
      end

      def on_contact(e)
        v = e.view
        @contact.call v.sprite, e.action if @contact && v.is_a?(View)
      end

      def will_contact?(v)
        return true if !@will_contact || !v.is_a?(View)
        @will_contact.call v.sprite
      end
    end

  end# Sprite


end# RubySketch
