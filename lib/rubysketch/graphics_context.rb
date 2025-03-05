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
      sprites.each {_1.drawSprite__ self}
      nil
    end

  end# GraphicsContext


end# RubySketch
