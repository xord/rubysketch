module RubySketch


  class Context < Processing::Context

    Sprite = RubySketch::Sprite
    Sound  = RubySketch::Sound

    # @private
    def initialize(window)
      super
      @timers__, @nextTimerID__ = {}, 0

      @layer__ = window.add_overlay SpriteLayer.new

      window.update_window = proc do
        fireTimers__
        Beeps.process_streams!
      end
    end

    # Calls block after specified seconds
    #
    # @param [Numeric] seconds Time at which the block is called
    # @param [Array]   args    Arguments passed to block
    # @param [Object]  id      Timer object identifier
    #
    # @return [Object] Timer object identifier
    #
    def setTimeout(seconds = 0, *args, id: nextTimerID__, &block)
      return unless block
      setTimeout__ id, Time.now.to_f + seconds, args, &block
    end

    # Repeats block call at each interval
    #
    # @param [Numeric] seconds Each interval duration
    # @param [Array]   args    Arguments passed to block
    # @param [Object]  id      Timer object identifier
    # @param [Boolean] now     Wheather or not to call the block right now
    #
    # @return [Object] Timer object identifier
    #
    def setInterval(seconds = 0, *args, id: nextTimerID__, now: false, &block)
      return unless block
      time = Time.now.to_f
      block.call *args if now
      setInterval__ id, time, seconds, args, &block
    end

    # @private
    def setTimeout__(id, time, args = [], &block)
      @timers__[id] = [time, args, block]
      id
    end

    # @private
    def setInterval__(id, startTime, seconds, args = [], &block)
      now, nextTime = Time.now.to_f, startTime + seconds
      nextTime      = now if nextTime < now
      setTimeout__ id, nextTime do
        block.call *args
        setInterval__ id, nextTime, seconds, args, &block
      end
    end

    # Stops timeout or interval timer by id
    #
    # @param [Object] id The identifier of timeout or interval timer to stop
    #
    # @return [nil] nil
    #
    def clearTimer(id)
      @timers__.delete id
      nil
    end

    alias clearTimeout  clearTimer
    alias clearInterval clearTimer

    # @private
    def nextTimerID__()
      @nextTimerID__ += 1
      @nextTimerID__
    end

    # @private
    def fireTimers__()
      now    = Time.now.to_f
      blocks = []
      @timers__.delete_if do |_, (time, args, block)|
        (now >= time).tap {|fire| blocks.push [block, args] if fire}
      end
      blocks.each {|block, args| block.call *args}
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
        next if sp.hidden?
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

    # Loads sound file.
    #
    # @param [String] path path for sound file
    #
    # @return [Sound] sound object
    #
    def loadSound(path)
      Sound.load path
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
