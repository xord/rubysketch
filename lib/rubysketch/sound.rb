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
      self.new Beeps::Sound.load path
    end

  end# Sound


end# RubySketch
