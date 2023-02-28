module RubySketch


  class Sprite

    extend Forwardable

    def initialize(x = 0, y = 0, w = nil, h = nil, image: nil, offset: nil, dynamic: false)
      w ||= image&.width  || 0
      h ||= image&.height || 0
      raise 'invalid size' unless w >= 0 && h >= 0

      @image__, @offset__ = image, offset
      @view__ = View.new self, x: x, y: y, w: w, h: h, back: :white, dynamic: dynamic
      CONTEXT.addSprite self
    end

    def_delegators :@view__,
      :x, :x=,
      :y, :y=,
      :w,     :h,
      :width, :height,
      :dynamic?,    :dynamic=,
      :density,     :density=,
      :friction,    :friction=,
      :restitution, :restitution=

    def update(&block)
      @view__.update = block
    end

    def contact(&block)
      @view__.contact = block
    end

    def position()
      @view__.position.toVector
    end

    def position=(vector)
      @view__.position = vector.getInternal__
    end

    def size()
      @view__.size.toVector
    end

    def image()
      @image__
    end

    def offset()
      @offset__
    end

    def velocity()
      @view__.velocity.toVector
    end

    def velocity=(vector)
      @view__.velocity = vector.getInternal__
    end

    alias pos   position
    alias pos=  position=
    alias vel   velocity
    alias vel=  velocity=
    alias dens  density
    alias dens= density=
    alias fric  friction
    alias fric= friction
    alias rest  restitution
    alias rest= restitution=

    # @private
    def getInternal__()
      @view__
    end

    class View < Reflex::View
      attr_accessor :update, :contact
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
    end

  end# Sprite


end# RubySketch
