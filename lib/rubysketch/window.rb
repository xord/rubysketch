module RubySketch


  # @private
  class Window < Processing::Window

    def on_update(e)
      Beeps.process_streams!
    end

  end# Window


end# RubySketch
