module RubySketch


  module GraphicsContext

    # Draws one or more sprites.
    #
    # @param [Array<Sprite>] sprites
    #
    def sprite(*sprites)
      sprites.flatten! if sprites.first&.is_a? Array
      sprites.each do |sp|
        view, draw = sp.getInternal__, sp.instance_variable_get(:@drawBlock__)
        f, angle   = view.frame, view.angle
        if draw
          push do
            translate f.x, f.y
            rotate radians(angle)
            draw.call {drawSprite__ sp, 0, 0, f.w, f.h}
          end
        elsif angle == 0
          drawSprite__ sp, f.x, f.y, f.w, f.h
        else
          pushMatrix do
            translate f.x, f.y
            rotate radians(angle)
            drawSprite__ sp, 0, 0, f.w, f.h
          end
        end
      end
    end

    # @private
    def drawSprite__(sp, x, y, w, h)
      img, off = sp.image, sp.offset
      if img && off
        copy img, off.x, off.y, w, h, x, y, w, h
      elsif img
        image img, x, y
      else
        rect x, y, w, h
      end
    end

  end# GraphicsContext


end# RubySketch
