module RubySketch


  class Sound

    # @private
    def initialize(sound)
      @sound = sound
    end

    def play()
      @sound&.play
    end

    def self.load(path)
      wav = Beeps::FileIn.new path
      self.new Beeps::Sound.new wav, wav.seconds, wav.nchannels
    end

  end# Sound


end# RubySketch
