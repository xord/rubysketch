module RubySketch


  # @private
  class Sound

    # @private
    def initialize(sound)
      @sound = sound
    end

    # Play sound.
    #
    def play()
      old = @player
      @player = @sound.play
      old&.stop
      true
    end

    # Pause sound.
    #
    def pause()
      return false unless @player
      @player.pause
      true
    end

    # Stop sound.
    #
    def stop()
      return false unless @player
      @player.stop
      @player = nil
      true
    end

    # Returns whether the sound is playing or not.
    #
    # @return [Boolean] playing or not
    #
    def playing?()
      @player ? @player.playing? : false
    end

    # Returns whether the sound is paused or not.
    #
    # @return [Boolean] paused or not
    #
    def paused?()
      @player ? @player.paused? : false
    end

    # Returns whether the sound is stopped or not.
    #
    # @return [Boolean] stopped or not
    #
    def stopped?()
      @player ? @player.stopped? : true
    end

    # Save the sound data to a file.
    #
    # @param [String] path file path
    #
    # @return [Sound] self
    #
    def save(path)
      @sound.save path
    end

    # Load a sound file.
    #
    # @param [String] path file path
    #
    # @return [Sound] sound object
    #
    def self.load(path)
      f = Beeps::FileIn.new path
      self.new Beeps::Sound.new(f, f.seconds, nchannels: f.nchannels)
    end

  end# Sound


end# RubySketch
