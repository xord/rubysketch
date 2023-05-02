module RubySketch


  # Sprite object.
  #
  class Sprite

    # Initialize sprite object.
    #
    # @overload new(image: img)
    #  pos: [0, 0], size: [image.width, image.height]
    #  @param [Image] img sprite image
    #
    # @overload new(x, y, image: img)
    #  pos: [x, y], size: [image.width, image.height]
    #  @param [Numeric] x   x of sprite position
    #  @param [Numeric] y   y of sprite position
    #  @param [Image]   img sprite image
    #
    # @overload new(x, y, w, h)
    #  pos(x, y), size: [w, h]
    #  @param [Numeric] x x of sprite position
    #  @param [Numeric] y y of sprite position
    #  @param [Numeric] w width of sprite
    #  @param [Numeric] h height of sprite
    #
    # @overload new(x, y, w, h, image: img, offset: off)
    #  pos: [x, y], size: [w, h], offset: [offset.x, offset.x]
    #  @param [Numeric] x   x of sprite position
    #  @param [Numeric] y   y of sprite position
    #  @param [Numeric] w   width of sprite
    #  @param [Numeric] h   height of sprite
    #  @param [Image]   img sprite image
    #  @param [Vector]  off offset of sprite image
    #
    def initialize(
      x = 0, y = 0, w = nil, h = nil, image: nil, offset: nil,
      context: nil)

      w ||= (image&.width  || 0)
      h ||= (image&.height || 0)
      raise 'invalid size'  unless w >= 0 && h >= 0
      raise 'invalid image' if image && !image.getInternal__.is_a?(Rays::Image)

      @context__ = context || Context.context__
      @view__    = SpriteView.new(
        self, x: x, y: y, w: w, h: h,
        static: true, density: 1, friction: 0, restitution: 0,
        back: :white)

      self.image  = image  if image
      self.offset = offset if offset
    end

    # Returns the position of the sprite.
    #
    # @return [Vector] position
    #
    def position()
      @view__.position.toVector
    end

    # Sets the position of the sprite.
    #
    # @overload position=(vec)
    #  @param [Vector] vec position vector
    #
    # @overload position=(ary)
    #  @param [Array<Numeric>] ary an array of positionX and positionY
    #
    # @return [Vector] position
    #
    def position=(arg)
      @view__.position = arg.is_a?(Vector) ? arg.getInternal__ : arg
      arg
    end

    # Returns the x-coordinate position of the sprite.
    #
    # @return [Numeric] sprite position x
    #
    def x()
      @view__.x
    end

    # Set the x-coordinate position of the sprite.
    #
    # @param [Numeric] n sprite position x
    #
    # @return [Numeric] sprite position x
    #
    def x=(n)
      @view__.x = n
      n
    end

    # Returns the y-coordinate position of the sprite.
    #
    # @return [Numeric] sprite position y
    #
    def y()
      @view__.y
    end

    # Set the y-coordinate position of the sprite.
    #
    # @param [Numeric] n sprite position y
    #
    # @return [Numeric] sprite position y
    #
    def y=(n)
      @view__.y = n
      n
    end

    alias pos  position
    alias pos= position=

    # Returns the size of the sprite.
    #
    # @return [Vector] size
    #
    def size()
      @view__.size.toVector
    end

    # Returns the width of the sprite.
    #
    # @return [Numeric] width
    #
    def width()
      @view__.width
    end

    # Returns the height of the sprite.
    #
    # @return [Numeric] height
    #
    def height()
      @view__.height
    end

    alias w width
    alias h height

    # Returns the rotation angle of sprite.
    #
    # @return [Numeric] radians or degrees depending on angleMode()
    #
    def angle()
      a, c = @view__.angle, @context__
      c ? c.fromDegrees__(a) : a * Processing::GraphicsContext::DEG2RAD__
    end

    # Sets the rotation angle of sprite.
    #
    # @param [Numeric] angle radians or degrees depending on angleMode()
    #
    # @return [Numeric] angle
    #
    def angle=(angle)
      c = @context__
      @view__.angle =
        c ? c.toAngle__(angle) : angle * Processing::GraphicsContext::RAD2DEG__
      angle
    end

    # Returns the velocity of the sprite.
    #
    # @return [Vector] velocity
    #
    def velocity()
      @view__.velocity.toVector
    end

    # Sets the velocity of the sprite.
    #
    # @overload velocity=(vec)
    #  @param [Vector] vec velocity vector
    #
    # @overload velocity=(ary)
    #  @param [Array<Numeric>] ary an array of velocityX and velocityY
    #
    # @return [Vector] velocity
    #
    def velocity=(arg)
      @view__.velocity = arg.is_a?(Vector) ? arg.getInternal__ : arg
      arg
    end

    # Returns the x-axis velocity of the sprite.
    #
    # @return [Numeric] velocity.x
    #
    def vx()
      @view__.velocity.x
    end

    # Sets the x-axis velocity of the sprite.
    #
    # @param [Numeric] n x-axis velocity
    #
    # @return [Numeric] velocity.x
    #
    def vx=(n)
      @view__.velocity = @view__.velocity.tap {|v| v.x = n}
      n
    end

    # Returns the y-axis velocity of the sprite.
    #
    # @return [Numeric] velocity.y
    #
    def vy()
      @view__.velocity.y
    end

    # Sets the y-axis velocity of the sprite.
    #
    # @param [Numeric] n y-axis velocity
    #
    # @return [Numeric] velocity.y
    #
    def vy=(n)
      @view__.velocity = @view__.velocity.tap {|v| v.y = n}
      n
    end

    alias vel  velocity
    alias vel= velocity=

    # Returns the image of the sprite.
    #
    # @return [Image] sprite image
    #
    def image()
      @image__
    end

    # Sets the sprite image.
    #
    # @param [Image] img sprite image
    #
    # @return [Image] sprite image
    #
    def image=(img)
      @image__ = img
    end

    # Returns the offset of the sprite image.
    #
    # @return [Vector] offset of the sprite image
    #
    def offset()
      @offset__
    end

    # Sets the offset of the sprite image.
    #
    # @overload offset=(vec)
    #  @param [Vector] vec offset
    #
    # @overload velocity=(ary)
    #  @param [Array<Numeric>] ary an array of offsetX and offsetY
    #
    # @return [Vector] offset of the sprite image
    #
    def offset=(arg)
      @offset__ =
        case arg
        when Vector then arg
        when Array  then Vector.new(arg[0] || 0, arg[1] || 0)
        when nil    then nil
        else raise ArgumentError
        end
      @offset__
    end

    # Returns the x-axis offset of the sprite image.
    #
    # @return [Numeric] offset.x
    #
    def ox()
      @offset__&.x || 0
    end

    # Sets the x-axis offset of the sprite image.
    #
    # @param [Numeric] n x-axis offset
    #
    # @return [Numeric] offset.x
    #
    def ox=(n)
      self.offset = [n, oy]
      n
    end

    # Returns the y-axis offset of the sprite image.
    #
    # @return [Numeric] offset.y
    #
    def oy()
      @offset__&.y || 0
    end

    # Sets the y-axis offset of the sprite image.
    #
    # @param [Numeric] n y-axis offset
    #
    # @return [Numeric] offset.y
    #
    def oy=(n)
      self.offset = [ox, n]
    end

    # Returns whether the sprite is movable by the physics engine.
    #
    # @return [Boolean] true if dynamic
    #
    def dynamic?()
      @view__.dynamic?
    end

    # Sets whether the sprite is movable by the physics engine.
    #
    # @param [Boolean] bool movable or not
    #
    # @return [Boolean] true if dynamic
    #
    def dynamic=(bool)
      @view__.dynamic = bool
      bool
    end

    # Returns the density of the sprite.
    #
    # @return [Numeric] density
    #
    def density()
      @view__.density
    end

    # Sets the density of the sprite.
    #
    # @param [Numeric] n density
    #
    # @return [Numeric] density
    #
    def density=(n)
      @view__.density = n
      n
    end

    # Returns the friction of the sprite.
    #
    # @return [Numeric] friction
    #
    def friction()
      @view__.friction
    end

    # Sets the friction of the sprite.
    #
    # @param [Numeric] n friction
    #
    # @return [Numeric] friction
    #
    def friction=(n)
      @view__.friction = n
      n
    end

    # Returns the restitution of the sprite.
    #
    # @return [Numeric] restitution
    #
    def restitution()
      @view__.restitution
    end

    # Sets the restitution of the sprite.
    #
    # @param [Numeric] n restitution
    #
    # @return [Numeric] restitution
    #
    def restitution=(n)
      @view__.restitution = n
      n
    end

    alias dens  density
    alias dens= density=
    alias fric  friction
    alias fric= friction=
    alias rest  restitution
    alias rest= restitution=

    # Returns the x-position of the mouse in the sprite coordinates.
    #
    # @return [Numeric] x position
    #
    def mouseX()
      @view__.mouseX
    end

    # Returns the y-position of the mouse in the sprite coordinates.
    #
    # @return [Numeric] y position
    #
    def mouseY()
      @view__.mouseY
    end

    # Returns the previous x-position of the mouse in the sprite coordinates.
    #
    # @return [Numeric] x position
    #
    def pmouseX()
      @view__.pmouseX
    end

    # Returns the previous y-position of the mouse in the sprite coordinates.
    #
    # @return [Numeric] y position
    #
    def pmouseY()
      @view__.pmouseY
    end

    # Returns the mouse button clicked on the sprite.
    #
    # @return [LEFT, RIGHT, CENTER] mouse button
    #
    def mouseButton()
      @view__.mouseButton
    end

    # Returns the touch objects touched on the sprite.
    #
    # @return [Array<Touch>] touches
    #
    def touches()
      @view__.touches
    end

    # Defines update block.
    #
    # @example vx is updated every frame
    #  sprite.update do
    #    self.vx *= 0.9
    #  end
    #
    # @return [nil] nil
    #
    def update(&block)
      @view__.update = block
    end

    # Defines draw block.
    #
    # @example Draw on your own before and after default drawing
    #  sprite.draw do |&defaultDrawSprite|
    #    rect 0, 0, 10, 10
    #    defaultDrawSprite.call
    #    text :hello, 10, 20
    #  end
    #
    # @return [nil] nil
    #
    def draw(&block)
      @drawBlock__ = block
      nil
    end

    # Defines mousePressed block.
    #
    # @example Print mouse states on mouse press
    #  sprite.mousePressed do
    #    p [sprite.mouseX, sprite.mouseY, sprite.mouseButton]
    #  end
    #
    # @return [nil] nil
    #
    def mousePressed(&block)
      @view__.mousePressed = block
      nil
    end

    # Defines mouseReleased block.
    #
    # @example Print mouse states on mouse release
    #  sprite.mouseReleased do
    #    p [sprite.mouseX, sprite.mouseY, sprite.mouseButton]
    #  end
    #
    # @return [nil] nil
    #
    def mouseReleased(&block)
      @view__.mouseReleased = block
      nil
    end

    # Defines mouseMoved block.
    #
    # @example Print mouse states on mouse move
    #  sprite.mouseMoved do
    #    p [sprite.mouseX, sprite.mouseY, sprite.pmouseX, sprite.pmouseY]
    #  end
    #
    # @return [nil] nil
    #
    def mouseMoved(&block)
      @view__.mouseMoved = block
      nil
    end

    # Defines mouseDragged block.
    #
    # @example Print mouse states on mouse drag
    #  sprite.mouseDragged do
    #    p [sprite.mouseX, sprite.mouseY, sprite.pmouseX, sprite.pmouseY]
    #  end
    #
    # @return [nil] nil
    #
    def mouseDragged(&block)
      @view__.mouseDragged = block
      nil
    end

    # Defines mouseClicked block.
    #
    # @example Print mouse states on mouse click
    #  sprite.mouseClicked do
    #    p [sprite.mouseX, sprite.mouseY, sprite.mouseButton]
    #  end
    #
    # @return [nil] nil
    #
    def mouseClicked(&block)
      @view__.mouseClicked = block
      nil
    end

    # Defines touchStarted block.
    #
    # @example Print touches on touch start
    #  sprite.touchStarted do
    #    p sprite.touches
    #  end
    #
    # @return [nil] nil
    #
    def touchStarted(&block)
      @view__.touchStarted = block
      nil
    end

    # Defines touchEnded block.
    #
    # @example Print touches on touch end
    #  sprite.touchEnded do
    #    p sprite.touches
    #  end
    #
    # @return [nil] nil
    #
    def touchEnded(&block)
      @view__.touchEnded = block
      nil
    end

    # Defines touchMoved block.
    #
    # @example Print touches on touch move
    #  sprite.touchMoved do
    #    p sprite.touches
    #  end
    #
    # @return [nil] nil
    #
    def touchMoved(&block)
      @view__.touchMoved = block
      nil
    end

    # Defines contact block.
    #
    # @example Score increases when the player sprite touches a coin
    #  playerSprite.contact do |o|
    #    score += 1 if o.coin?
    #  end
    #
    # @return [nil] nil
    #
    def contact(&block)
      @view__.contact = block
    end

    # Defines contact? block.
    #
    # @example Only collide with an enemy
    #  playerSprite.contact? do |o|
    #    o.enemy?
    #  end
    #
    # @return [nil] nil
    #
    def contact?(&block)
      @view__.will_contact = block
    end

    # @private
    def getInternal__()
      @view__
    end

  end# Sprite


  # @private
  class SpriteView < Reflex::View

    attr_accessor :update,
      :mousePressed, :mouseReleased, :mouseMoved, :mouseDragged, :mouseClicked,
      :touchStarted, :touchEnded, :touchMoved,
      :contact, :will_contact

    attr_reader :sprite, :touches

    def initialize(sprite, *a, **k, &b)
      @sprite = sprite
      super(*a, **k, &b)

      @pointerPos       =
      @pointerPrevPos   = Rays::Point.new 0
      @pointersPressed  = []
      @pointersReleased = []
      @touches          = []
    end

    def mouseX()
      @pointerPos.x
    end

    def mouseY()
      @pointerPos.y
    end

    def pmouseX()
      @pointerPrevPos.x
    end

    def pmouseY()
      @pointerPrevPos.y
    end

    def mouseButton()
      ((@pointersPressed + @pointersReleased) & [LEFT, RIGHT, CENTER]).last
    end

    def on_update(e)
      @update&.call
    end

    def on_pointer_down(e)
      updatePointerStates e, true
      @pointerDownStartPos = @pointerPos.dup
      (@touchStarted || @mousePressed)&.call
    end

    def on_pointer_up(e)
      updatePointerStates e, false
      (@touchEnded || @mouseReleased)&.call
      if startPos = @pointerDownStartPos
        @mouseClicked&.call if (@pointerPos - startPos).length < 3
        @pointerDownStartPos = nil
      end
      @pointersReleased.clear
    end

    def on_pointer_move(e)
      updatePointerStates e
      (@touchMoved || (e.drag? ? @mouseDragged : @mouseMoved))&.call
    end

    def on_pointer_cancel(e)
      on_pointer_up e
    end

    def on_contact(e)
      v = e.view
      @contact.call v.sprite, e.action if @contact && v.respond_to?(:sprite)
    end

    def will_contact?(v)
      return true unless @will_contact && v.respond_to?(:sprite)
      @will_contact.call v.sprite
    end

    private

    MOUSE_BUTTON_MAP = {
      mouse_left:   Processing::GraphicsContext::LEFT,
      mouse_right:  Processing::GraphicsContext::RIGHT,
      mouse_middle: Processing::GraphicsContext::CENTER
    }

    def updatePointerStates(event, pressed = nil)
      @pointerPrevPos = @pointerPos
      @pointerPos     = event.pos.dup
      @touches        = event.pointers.map {|p| Touch.new(p.id, *p.pos.to_a)}
      if pressed != nil
        event.types
          .tap {|types| types.delete :mouse}
          .map {|type| MOUSE_BUTTON_MAP[type] || type}
          .each do |type|
            (pressed ? @pointersPressed : @pointersReleased).push type
            @pointersPressed.delete type unless pressed
          end
      end
    end

  end# SpriteView


end# RubySketch
