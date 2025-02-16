module RubySketch


  module GraphicsContext

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

  end# GraphicsContext


end# RubySketch
