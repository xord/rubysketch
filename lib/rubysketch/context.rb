module RubySketch


  class Context < Processing::Context

    include GraphicsContext

    # @private
    def initialize(window)
      super
      @sprites__ = window.add SpritesView.new
    end

    def createSprite(*args, **kwargs)
      addSprite Sprite.new(*args, **kwargs)
    end

    def addSprite(sprite)
      @sprites__.add sprite.getInternal__ if sprite
      sprite
    end

    def removeSprite(sprite)
      @sprites__.remove sprite.getInternal__ if sprite
      sprite
    end

    def loadSound(path)
      Sound.load path
    end

    def gravity(*args)
      x, y =
        case args
        when Processing::Vector then args.array
        else args
        end
      @sprites__.then do |v|
        v.gravity x * v.meter, y * v.meter
      end
    end

    # @private
    class SpritesView < Reflex::View
      def on_draw(e)
        e.block
      end
    end

  end# Context


end# RubySketch
