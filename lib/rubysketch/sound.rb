module RubySketch


  class Sound

    # @private
    def initialize(sound)
      @sound = sound
    end

    def play()
      old = @player
      @player = @sound.play
      old&.stop
      true
    end

    def pause()
      return false unless @player
      @player.pause
      true
    end

    def stop()
      return false unless @player
      @player.stop
      @player = nil
      true
    end

    def playing?()
      @player ? @player.playing? : false
    end

    def paused?()
      !playing? && !stopped?
    end

    def stopped?()
      @player ? @player.stopped? : true
    end

    def save(path)
      @sound.save path
    end

    def self.load(path)
      f = Beeps::FileIn.new path
      self.new Beeps::Sound.new(f, f.seconds, nchannels: f.nchannels)
    end

  end# Sound


end# RubySketch
