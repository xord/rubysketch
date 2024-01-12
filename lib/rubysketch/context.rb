module RubySketch


  class Context < Processing::Context

    Sprite = RubySketch::Sprite
    Circle = RubySketch::Circle
    Sound  = RubySketch::Sound

    # @private
    def initialize(window)
      super
      @timers__, @firingTimers__, @nextTimerID__ = {}, {}, 0

      @layer__ = window.add_overlay SpriteLayer.new

      window.update_window = proc do
        fireTimers__
        Beeps.process_streams!
      end

      noSmooth
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
      block.call(*args) if now
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
        setInterval__ id, nextTime, seconds, args, &block
        block.call(*args)
      end
    end

    # Stops timeout or interval timer by id
    #
    # @param [Object] id The identifier of timeout or interval timer to stop
    #
    # @return [nil] nil
    #
    def clearTimer(id)
      [@timers__, @firingTimers__].each {|timers| timers.delete id}
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
      @firingTimers__.clear
      @timers__.delete_if do |id, (time, args, block)|
        (now >= time).tap {|fire| @firingTimers__[id] = [block, args] if fire}
      end
      @firingTimers__.each {|_, (block, args)| block.call(*args)}
    end

    # Animate with easing functions
    #
    # @param [Numeric] seconds Animation duration
    # @param [Object]  id      Timer object identifier
    # @param [Symbol]  easing  Easing function name
    #
    # @return [Object] Timer object identifier
    #
    def animate(seconds, id: nextTimerID__, easing: :expoOut, &block)
      fun   = EASINGS[easing] or raise "'#{easing}' easing function not found"
      start = Time.now.to_f
      eachDrawBlock = lambda do
        t = (Time.now.to_f - start) / seconds
        if t >= 1.0
          block.call fun.call(1.0), true
        else
          block.call fun.call(t), false
          setTimeout 0, id: id, &eachDrawBlock
        end
      end
      setTimeout 0, id: id, &eachDrawBlock
    end

    # Animate value with easing functions
    #
    # @param [Numeric]         seconds Animation duration
    # @param [Numeric, Vector] from    Value at the beggining of the animation
    # @param [Numeric, Vector] to      Value at the end of the animation
    # @param [Object]          id      Timer object identifier
    # @param [Symbol]          easing  Easing function name
    #
    # @return [Object] Timer object identifier
    #
    def animateValue(seconds, from:, to:, id: nextTimerID__, easing: :expoOut, &block)
      if from.is_a? Vector
        animate seconds, id: id, easing: easing do |t, finished|
          block.call Vector.lerp(from, to, t), finished
        end
      else
        animate seconds, id: id, easing: easing do |t, finished|
          block.call        lerp(from, to, t), finished
        end
      end
    end

    # Creates a new sprite and add it to physics engine.
    #
    # @overload createSprite(x, y, w, h)
    #  pos(x, y), size: [w, h]
    #  @param [Numeric] x x of the sprite position
    #  @param [Numeric] y y of the sprite position
    #  @param [Numeric] w width of the sprite
    #  @param [Numeric] h height of the sprite
    #
    # @overload createSprite(image: img)
    #  pos: [0, 0], size: [image.width, image.height]
    #  @param [Image] img sprite image
    #
    # @overload createSprite(x, y, image: img)
    #  pos: [x, y], size: [image.width, image.height]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Image]   img sprite image
    #
    # @overload createSprite(x, y, image: img, offset: off)
    #  pos: [x, y], size: [image.width, image.height], offset: [offset.x, offset.x]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Image]   img sprite image
    #  @param [Vector]  off offset of the sprite image
    #
    # @overload createSprite(x, y, image: img, shape: shp)
    #  pos: [x, y], size: [image.width, image.height]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Image]   img sprite image
    #
    # @overload createSprite(x, y, image: img, offset: off, shape: shp)
    #  pos: [x, y], size: [image.width, image.height], offset: [offset.x, offset.x]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Image]   img sprite image
    #  @param [Vector]  off offset of the sprite image
    #  @param [Shape]   shp shape of the sprite for physics calculations
    #
    # @overload createSprite(x, y, shape: shp)
    #  pos: [x, y], size: [shape.width, shape.height]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Shape]   shp shape of the sprite for physics calculations
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
            draw.call {sp.draw__ self, 0, 0, f.w, f.h}
          end
        elsif degrees == 0
          sp.draw__ self, f.x, f.y, f.w, f.h
        else
          pushMatrix do
            translate f.x + pivot.x  * f.w, f.y + pivot.y  * f.h
            rotate fromDegrees__ degrees
            translate     (-pivot.x) * f.w,     (-pivot.y) * f.h
            sp.draw__ self, 0, 0, f.w, f.h
          end
        end
      end
      nil
    end

    alias drawSprite sprite

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

    # Generates haptic feedback
    #
    # @return [nil] nil
    #
    def vibrate ()
      Reflex.vibrate
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
