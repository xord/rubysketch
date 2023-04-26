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
        f, angle, img, offset = v.frame, v.angle, sp.image, sp.offset
        if angle == 0
          drawSprite__ f.x, f.y, f.w, f.h, img, offset
        else
          pushMatrix do
            translate f.x, f.y
            rotate radians(angle)
            drawSprite__ 0, 0, f.w, f.h, img, offset
          end
        end
      end
    end

    # @private
    def drawSprite__(x, y, w, h, img, offset)
      if img && offset
        ox, oy = offset
        copy img, ox, oy, w, h, x, y, w, h
      elsif img
        image img, x, y
      else
        rect x, y, w, h
      end
    end

  end# GraphicsContext


end# RubySketch
