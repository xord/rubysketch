module RubySketch


  class Context < Processing::Context

    Sprite = RubySketch::Sprite

    # @private
    def initialize(window)
      super
      @layer__ = window.add_overlay SpriteLayer.new
    end

    # Creates a new sprite and add it to physics engine.
    #
    # @overload createSprite(image: img)
    #  pos: [0, 0], size: [image.width, image.height]
    #  @param [Image] img sprite image
    #
    # @overload createSprite(x, y, image: img)
    #  pos: [x, y], size: [image.width, image.height]
    #  @param [Numeric] x   x of sprite position
    #  @param [Numeric] y   y of sprite position
    #  @param [Image]   img sprite image
    #
    # @overload createSprite(x, y, w, h)
    #  pos(x, y), size: [w, h]
    #  @param [Numeric] x x of sprite position
    #  @param [Numeric] y y of sprite position
    #  @param [Numeric] w width of sprite
    #  @param [Numeric] h height of sprite
    #
    # @overload createSprite(x, y, w, h, image: img, offset: off)
    #  pos: [x, y], size: [w, h], offset: [offset.x, offset.x]
    #  @param [Numeric] x   x of sprite position
    #  @param [Numeric] y   y of sprite position
    #  @param [Numeric] w   width of sprite
    #  @param [Numeric] h   height of sprite
    #  @param [Image]   img sprite image
    #  @param [Vector]  off offset of sprite image
    #
    def createSprite(*args, **kwargs)
      addSprite Sprite.new(*args, **kwargs, context: self)
    end

    # Adds the sprite to the physics engine.
    #
    # @param [Sprite] sprite sprite object
    #
    # @return [Sprite] added sprite
    #
    def addSprite(sprite)
      @layer__.add sprite.getInternal__ if sprite
      sprite
    end

    # Removes the sprite from the physics engine.
    #
    # @param [Sprite] sprite sprite object
    #
    # @return [Sprite] removed sprite
    #
    def removeSprite(sprite)
      @layer__.remove sprite.getInternal__ if sprite
      sprite
    end

    # Draws one or more sprites.
    #
    # @param [Array<Sprite>] sprites
    #
    # @return [nil] nil
    #
    def sprite(*sprites)
      sprites.flatten! if sprites.first&.is_a? Array
      sprites.each do |sp|
        view, draw = sp.getInternal__, sp.instance_variable_get(:@drawBlock__)
        f, degrees, pivot = view.frame, view.angle, view.pivot
        if draw
          push do
            translate f.x + pivot.x  * f.w, f.y + pivot.y  * f.h
            rotate fromDegrees__ degrees
            translate     (-pivot.x) * f.w,     (-pivot.y) * f.h
            draw.call {drawSprite__ sp, 0, 0, f.w, f.h}
          end
        elsif degrees == 0
          drawSprite__ sp, f.x, f.y, f.w, f.h
        else
          pushMatrix do
            translate f.x + pivot.x  * f.w, f.y + pivot.y  * f.h
            rotate fromDegrees__ degrees
            translate     (-pivot.x) * f.w,     (-pivot.y) * f.h
            drawSprite__ sp, 0, 0, f.w, f.h
          end
        end
      end
      nil
    end

    alias drawSprite sprite

    # @private
    def drawSprite__(sp, x, y, w, h)
      img, off = sp.image, sp.offset
      if img && off
        copy img, off.x, off.y, w, h, x, y, w, h
      elsif img
        image img, x, y
      else
        rect x, y, w, h
      end
    end

    # Sets gravity for the physics engine.
    #
    # @overload gravity(vec)
    #  @param [Vector] vec gracity vector
    #
    # @overload gravity(ary)
    #  @param [Array<Numeric>] ary gravityX, gravityY
    #
    # @overload gravity(x, y)
    #  @param [Numeric] x x of gravity vector
    #  @param [Numeric] y y of gracity vector
    #
    def gravity(*args)
      x, y =
        case arg = args.first
        when Vector then arg.array
        when Array  then arg
        else args
        end
      @layer__.gravity x, y
    end

  end# Context


  # @private
  class SpriteLayer < Reflex::View

    def initialize(*a, **k, &b)
      super
      remove wall
    end

    def on_draw(e)
      e.block false
    end

  end# SpriteLayer


end# RubySketch
