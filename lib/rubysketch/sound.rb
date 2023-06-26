module RubySketch


  # Sound object.
  #
  class Sound

    # @private
    def initialize(sound)
      @sound   = sound
      @players = []
    end

    # Play sound.
    #
    # @param [Numeric] gain volume for playing sound
    #
    # @return [nil] nil
    #
    def play(gain: 1.0)
      clean_stopped_players
      @players.push @sound.play(gain: gain)
      nil
    end

    # Stop playing sounds.
    #
    # @return [nil] nil
    #
    def stop()
      @players.each &:stop
      @players.clear
      nil
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

    private

    # @private
    def clean_stopped_players()
      @players.delete_if {|p| not p.playing?}
    end

  end# Sound


end# RubySketch
