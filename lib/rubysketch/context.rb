module RubySketch


  class Context < Processing::Context

    include GraphicsContext

    Sprite      = RubySketch::Sprite
    SpriteWorld = RubySketch::SpriteWorld
    Circle      = RubySketch::Circle
    Sound       = RubySketch::Sound

    # @private
    def initialize(window)
      super
      @window__          = window
      @timers__          = {}
      @firingTimers__    = {}
      @nextTimerID__     = 0
      @noteNumber__      = 69
      @noteFrequency__   = 440
      @noteVelocity__    = 1
      @controllerIndex__ = 0
      @controllerValue__ = 0

      @world__ = createWorld

      updateNoteStates = -> event {
        @noteNumber__    = event.note
        @noteFrequency__ = event.frequency
        @noteVelocity__  = event.velocity
      }

      updateControllerStates = -> event {
        @controllerIndex__ = event.controller
        @controllerValue__ = event.value
      }

      @window__.update_window = proc do
        fireTimers__
        Beeps.process_streams!
        Reflex.process_events!
      end

      @window__.note_on  = proc do |e|
        updateNoteStates.call e
        @notePressedBlock__&.call
      end

      @window__.note_off = proc do |e|
        updateNoteStates.call e
        @noteReleasedBlock__&.call
      end

      @window__.control_change = proc do |e|
        updateControllerStates.call e
        @controlChangeBlock__&.call
      end

      noSmooth
    end

    # @private
    def hasUserBlocks__()
      super ||
      @notePressedBlock__  ||
      @noteReleasedBlock__ ||
      @controlChangeBlock__
    end

    # Defines notePressed block.
    #
    # @return [nil] nil
    #
    def notePressed(&block)
      @notePressedBlock__ = block if block
      nil
    end

    # Defines noteReleased block.
    #
    # @return [nil] nil
    #
    def noteReleased(&block)
      @noteReleasedBlock__ = block if block
      nil
    end

    # Defines controlChange block.
    #
    # @return [nil] nil
    #
    def controlChange(&block)
      @controlChangeBlock__ = block if block
      nil
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
          setTimeout id: id, &eachDrawBlock
        end
      end
      setTimeout id: id, &eachDrawBlock
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
    # @return [Sprite] the new sprite object
    #
    def createSprite(*args, **kwargs)
      @world__.createSprite(*args, context: self, **kwargs)
    end

    # Adds sprite to the physics engine.
    #
    # @param [Array]  array user array to store the sprite
    # @param [Sprite] sprite sprite object
    #
    # @return [Sprite] the added sprite
    #
    def addSprite(array = nil, sprite)
      @world__.addSprite array, sprite
    end

    # Removes sprite from the physics engine.
    #
    # @param [Array]  array user array to remove the sprite
    # @param [Sprite] sprite sprite object
    #
    # @return [Sprite] the removed sprite
    #
    def removeSprite(array = nil, sprite)
      @world__.removeSprite array, sprite
    end

    alias drawSprite sprite

    # Creates a new world to calculate the physics of sprites.
    #
    # @return [SpriteWorld] the new world object
    #
    def createWorld(pixelsPerMeter: 0)
      addWorld SpriteWorld.new pixelsPerMeter: pixelsPerMeter
    end

    # Adds worlds
    #
    # @param [SpriteWorld] worlds world objects
    #
    # @return [SpriteWorld] first added world
    #
    def addWorld(*worlds)
      worlds.each {@window__.add_overlay _1.getInternal__}
      worlds.first
    end

    # Removes worlds
    #
    # @param [SpriteWorld] worlds world objects
    #
    # @return [SpriteWorld] first removed world
    #
    def removeWorld(*worlds)
      worlds.each {@window__.remove_overlay _1.getInternal__}
      worlds.first
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

    # Returns the last note number that was pressed or released.
    #
    # @return [Numeric] last note number
    #
    def noteNumber()
      @noteNumber__
    end

    # Returns the last note frequency that was pressed or released.
    #
    # @return [Numeric] last note frequency
    #
    def noteFrequency()
      @noteFrequency__
    end

    # Returns the last note velocity that was pressed or released.
    #
    # @return [Numeric] last note velocity
    #
    def noteVelocity()
      @noteVelocity__
    end

    # Returns the last controller index that was changed.
    #
    # @return [Numeric] last controller index
    #
    def controllerIndex()
      @controllerIndex__
    end

    # Returns the last controller value that was changed.
    #
    # @return [Numeric] last controller value
    #
    def controllerValue()
      @controllerValue__
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
    # @return [nil] nil
    #
    def gravity(...)
      @world__.gravity(...)
    end

    # Generates haptic feedback
    #
    # @return [nil] nil
    #
    def vibrate()
      Reflex.vibrate
    end

  end# Context


end# RubySketch
