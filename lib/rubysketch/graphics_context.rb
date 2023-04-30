module RubySketch


  module GraphicsContext

    # Draws one or more sprites.
    #
    # @param [Array<Sprite>] sprites
    #
    def sprite(*sprites)
      sprites.flatten! if sprites.first&.is_a? Array
      sprites.each do |sp|
        v = sp.getInternal__
        f, angle = v.frame, v.angle
        if angle == 0
          sp.on_draw__ f.x, f.y, f.w, f.h
        else
          pushMatrix do
            translate f.x, f.y
            rotate radians(angle)
            sp.on_draw__ 0, 0, f.w, f.h
          end
        end
      end
    end

  end# GraphicsContext


end# RubySketch
