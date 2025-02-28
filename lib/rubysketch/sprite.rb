module RubySketch


  # Sprite object.
  #
  class Sprite

    include Xot::Inspectable

    # Initialize sprite object.
    #
    # @overload new(x, y, w, h)
    #  pos(x, y), size: [w, h]
    #  @param [Numeric] x x of the sprite position
    #  @param [Numeric] y y of the sprite position
    #  @param [Numeric] w width of the sprite
    #  @param [Numeric] h height of the sprite
    #
    # @overload new(image: img)
    #  pos: [0, 0], size: [image.width, image.height]
    #  @param [Image] img sprite image
    #
    # @overload new(x, y, image: img)
    #  pos: [x, y], size: [image.width, image.height]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Image]   img sprite image
    #
    # @overload new(x, y, image: img, offset: off)
    #  pos: [x, y], size: [image.width, image.height], offset: [offset.x, offset.x]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Image]   img sprite image
    #  @param [Vector]  off offset of the sprite image
    #
    # @overload new(x, y, image: img, shape: shp)
    #  pos: [x, y], size: [image.width, image.height]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Image]   img sprite image
    #
    # @overload new(x, y, image: img, offset: off, shape: shp)
    #  pos: [x, y], size: [image.width, image.height], offset: [offset.x, offset.x]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Image]   img sprite image
    #  @param [Vector]  off offset of the sprite image
    #  @param [Shape]   shp shape of the sprite for physics calculations
    #
    # @overload new(x, y, shape: shp)
    #  pos: [x, y], size: [shape.width, shape.height]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Shape]   shp shape of the sprite for physics calculations
    #
    def initialize(
      x = 0, y = 0, w = nil, h = nil, image: nil, offset: nil, shape: nil,
      physics: true, context: nil)

      w ||= (image&.width  || shape&.width  || 0)
      h ||= (image&.height || shape&.height || 0)
      raise 'invalid size'  unless w >= 0 && h >= 0
      raise 'invalid image' if image && !image.getInternal__.is_a?(Rays::Image)
      raise 'invalid shape' if shape && !shape.getInternal__.is_a?(Reflex::Shape)

      @context__ = context || Context.context__
      @shape__   = shape
      @view__    = View.new(
        self, x: x, y: y, w: w, h: h,
        shape: @shape__, physics: physics, back: :white)
      @view__.set density: 1, friction: 0, restitution: 0

      self.image  = image  if image
      self.offset = offset if offset
    end

    # Shows the sprite
    #
    # Since one call to "hide()" increases the hide count, it is necessary to call "show()" n times to make the sprite visible again after calling "hide()" n times.
    #
    # @return [Sprite] self
    #
    def show()
      @view__.show
      self
    end

    # Hides the sprite
    #
    # Since one call to "hide()" increases the hide count, it is necessary to call "show()" n times to make the sprite visible again after calling "hide()" n times.
    #
    # @return [Sprite] self
    #
    def hide()
      @view__.hide
      self
    end

    # Returns the sprite is visible
    #
    # @return [Boolean] true: invisible, false: visible
    #
    def hidden?()
      @view__.hidden?
    end

    # Captures key and mouse events
    #
    # @param [Boolean] bool whether to capture
    #
    # @return [Boolean] the current state
    #
    def capture=(bool)
      @view__.capture = bool ? :all : []
      bool
    end

    # Returns whether to capture or not
    #
    # @return [Boolean] whether to capture
    #
    def capturing?()
      @view__.capturing?
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

    # Returns the z-coordinate position of the sprite.
    #
    # @return [Numeric] sprite position z
    #
    def z()
      @view__.z
    end

    # Set the z-coordinate position of the sprite.
    #
    # @param [Numeric] n sprite position z
    #
    # @return [Numeric] sprite position z
    #
    def z=(n)
      @view__.z = n
      n
    end

    alias pos  position
    alias pos= position=

    # Returns the left position of the sprite.
    #
    # @return [Numeric] left position
    #
    def left()
      @view__.left
    end

    # Set the left position of the sprite.
    #
    # @param [Numeric] n sprite left position
    #
    # @return [Numeric] sprite left position
    #
    def left=(n)
      @view__.left = n
      n
    end

    # Returns the top position of the sprite.
    #
    # @return [Numeric] top position
    #
    def top()
      @view__.top
    end

    # Set the top position of the sprite.
    #
    # @param [Numeric] n sprite top position
    #
    # @return [Numeric] sprite top position
    #
    def top=(n)
      @view__.top = n
    end

    # Returns the right position of the sprite.
    #
    # @return [Numeric] right position
    #
    def right()
      @view__.right
    end

    # Set the right position of the sprite.
    #
    # @param [Numeric] n sprite right position
    #
    # @return [Numeric] sprite right position
    #
    def right=(n)
      @view__.right = n
    end

    # Returns the bottom position of the sprite.
    #
    # @return [Numeric] bottom
    #
    def bottom()
      @view__.bottom
    end

    # Set the bottom position of the sprite.
    #
    # @param [Numeric] n sprite bottom position
    #
    # @return [Numeric] sprite bottom position
    #
    def bottom=(n)
      @view__.bottom = n
    end

    # Returns the center position of the sprite.
    #
    # @return [Vector] center position
    #
    def center()
      Vector.new(x + w / 2, y + h / 2, z)
    end

    # Sets the center position of the sprite.
    #
    # @overload center=(vec)
    #  @param [Vector] vec center position
    #
    # @overload center=(ary)
    #  @param [Array<Numeric>] ary an array of centerX and centerY
    #
    # @return [Vector] center position
    #
    def center=(arg)
      x, y = *(arg.is_a?(Vector) ? arg.getInternal__.to_a : arg)
      self.pos = [x - w / 2, y - h / 2, z]
      self.center
    end

    # Returns the size of the sprite.
    #
    # @return [Vector] size
    #
    def size()
      @view__.size.toVector
    end

    # Returns the size of the sprite.
    #
    # @return [Vector] size
    #
    def size=(arg)
      @view__.size = arg.is_a?(Vector) ? arg.getInternal__ : arg
      arg
    end

    # Returns the width of the sprite.
    #
    # @return [Numeric] width
    #
    def width()
      @view__.width
    end

    # Sets the width of the sprite.
    #
    # @param [Numeric] w width
    #
    # @return [Numeric] width
    #
    def width=(w)
      @view__.width = w
    end

    # Returns the height of the sprite.
    #
    # @return [Numeric] height
    #
    def height()
      @view__.height
    end

    # Sets the height of the sprite.
    #
    # @param [Numeric] h height
    #
    # @return [Numeric] height
    #
    def height=(h)
      @view__.height = h
    end

    alias w  width
    alias w= width=
    alias h  height
    alias h= height=

    # Returns the rotation angle of the sprite.
    #
    # @return [Numeric] radians or degrees depending on angleMode()
    #
    def angle()
      a, c = @view__.angle, @context__
      c ? c.fromDegrees__(a) : a * Processing::GraphicsContext::DEG2RAD__
    end

    # Sets the rotation angle of the sprite.
    #
    # @param [Numeric] angle radians or degrees depending on angleMode()
    #
    # @return [Numeric] angle
    #
    def angle=(angle)
      c = @context__
      @view__.angle =
        c ? c.toDegrees__(angle) : angle * Processing::GraphicsContext::RAD2DEG__
      angle
    end

    # Fixes the angle of the sprite.
    #
    # @param [Boolean] fix fix rotation or not
    #
    # @return [Sprite] self
    #
    def fixAngle(fix = true)
      @view__.fix_angle = fix
      self
    end

    # Returns the angle of the sprite is fixed or not.
    #
    # @return [Boolean] whether the rotation is fixed or not
    #
    def angleFixed?()
      @view__.fix_angle?
    end

    # Returns the rotation center of the sprite.
    #
    # @return [Array<Numeric>] [pivotX, pivotY]
    #
    def pivot()
      @view__.pivot.to_a[0, 2]
    end

    # Sets the rotation center of the sprite.
    # [0.0, 0.0] is the left-top, [1.0, 1.0] is the right-bottom, and [0.5, 0.5] is the center.
    #
    # @param [Array<Numeric>] array an array of pivotX and pivotY
    #
    # @return [Array<Numeric>] [pivotX, pivotY]
    #
    def pivot=(array)
      @view__.pivot = array
      pivot
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
    # @overload offset=(ary)
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
      offset
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
    # @param [Numeric] x x-axis offset
    #
    # @return [Numeric] offset.x
    #
    def ox=(x)
      self.offset = [x, oy]
      x
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
    # @param [Numeric] y y-axis offset
    #
    # @return [Numeric] offset.y
    #
    def oy=(y)
      self.offset = [ox, y]
      y
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

    # Set this sprite as a sensor object.
    # Sensor object receives contact events, but no collisions.
    #
    # @return [Boolean] sensor or not
    #
    def sensor=(state)
      @view__.sensor = state
    end

    # Returns weather the shape is a sensor or not.
    #
    # @return [Boolean] sensor or not
    #
    def sensor?()
      @view__.sensor?
    end

    # Converts a vector from the screen coordinate
    #
    # @param [Vector] vec screen coordinate vector
    #
    # @return [Vector] sprite coordinate vector
    #
    def fromScreen(vec)
      @view__.from_parent(vec.getInternal__).toVector
    end

    # Converts a vector to the screen coordinate
    #
    # @param [Vector] vec sprite coordinate vector
    #
    # @return [Vector] screen coordinate vector
    #
    def toScreen(vec)
      @view__.to_parent(vec.getInternal__).toVector
    end

    # Returns the last key that was pressed or released.
    #
    # @return [String] last key
    #
    def key()
      @view__.key
    end

    # Returns the last key code that was pressed or released.
    #
    # @return [Symbol] last key code
    #
    def keyCode()
      @view__.keyCode
    end

    # Returns whether or not any key is pressed.
    #
    # @return [Boolean] is any key pressed or not
    #
    def keyIsPressed()
      not @view__.keysPressed.empty?
    end

    # Returns weather or not the key is currently pressed.
    #
    # @param keyCode [Numeric] code for the key
    #
    # @return [Boolean] is the key pressed or not
    #
    def keyIsDown(keyCode)
      @view__.keysPressed.include? keyCode
    end

    # Returns whether the current key is repeated or not.
    #
    # @return [Boolean] is the key repeated or not
    #
    def keyIsRepeated()
      @view__.keyRepeat
    end

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

    # Returns the mouse button click count on the sprite.
    #
    # @return [Numeric] click count
    #
    def clickCount()
      @view__.clickCount
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
      @view__.update = block if block
      nil
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
      @drawBlock__ = block if block
      nil
    end

    # Defines keyPressed block.
    #
    # @return [Boolean] is any key pressed or not
    #
    def keyPressed(&block)
      @view__.keyPressed = block if block
      keyIsPressed
    end

    # Defines keyReleased block.
    #
    # @return [nil] nil
    #
    def keyReleased(&block)
      @view__.keyReleased = block if block
      nil
    end

    # Defines keyTyped block.
    #
    # @return [nil] nil
    #
    def keyTyped(&block)
      @view__.keyTyped = block if block
      nil
    end

    # Defines mousePressed block.
    #
    # @example Print mouse states on mouse press
    #  sprite.mousePressed do
    #    p [sprite.mouseX, sprite.mouseY, sprite.mouseButton]
    #  end
    #
    # @return [Boolean] is any mouse button pressed or not
    #
    def mousePressed(&block)
      @view__.mousePressed = block if block
      @view__.mousePressed?
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
      @view__.mouseReleased = block if block
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
      @view__.mouseMoved = block if block
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
      @view__.mouseDragged = block if block
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
      @view__.mouseClicked = block if block
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
      @view__.touchStarted = block if block
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
      @view__.touchEnded = block if block
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
      @view__.touchMoved = block if block
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
      @view__.contact = block if block
      nil
    end

    # Defines contactEnd block.
    #
    # @example Call jumping() when the player sprite leaves the ground sprite
    #  playerSprite.contactEnd do |o|
    #    jumping if o == groundSprite
    #  end
    #
    # @return [nil] nil
    #
    def contactEnd(&block)
      @view__.contactEnd = block if block
      nil
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
      @view__.willContact = block if block
      nil
    end

    # @private
    def getInternal__()
      @view__
    end

    # @private
    def draw__(c, x, y, w, h)
      img, off = @image__, @offset__
      if img && off
        c.copy img, off.x, off.y, w, h, x, y, w, h
      elsif img
        c.image img, x, y
      elsif @shape__
        @shape__.draw__ c, x, y, w, h
      else
        c.rect x, y, w, h
      end
    end

  end# Sprite


  # A class Manages sprites.
  #
  class SpriteWorld

    # Create a new physics world.
    #
    def initialize(pixelsPerMeter: 0)
      @view, @debug = View.new(pixelsPerMeter: pixelsPerMeter), false
    end

    # Creates a new sprite and add it to physics engine.
    #
    # @overload createSprite(x, y, w, h)
    #  pos(x, y), size: [w, h]
    #  @param [Numeric] x x of the sprite position
    #  @param [Numeric] y y of the sprite position
    #  @param [Numeric] w width of the sprite
    #  @param [Numeric] h height of the sprite
    #
    # @overload createSprite(image: img)
    #  pos: [0, 0], size: [image.width, image.height]
    #  @param [Image] img sprite image
    #
    # @overload createSprite(x, y, image: img)
    #  pos: [x, y], size: [image.width, image.height]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Image]   img sprite image
    #
    # @overload createSprite(x, y, image: img, offset: off)
    #  pos: [x, y], size: [image.width, image.height], offset: [offset.x, offset.x]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Image]   img sprite image
    #  @param [Vector]  off offset of the sprite image
    #
    # @overload createSprite(x, y, image: img, shape: shp)
    #  pos: [x, y], size: [image.width, image.height]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Image]   img sprite image
    #
    # @overload createSprite(x, y, image: img, offset: off, shape: shp)
    #  pos: [x, y], size: [image.width, image.height], offset: [offset.x, offset.x]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Image]   img sprite image
    #  @param [Vector]  off offset of the sprite image
    #  @param [Shape]   shp shape of the sprite for physics calculations
    #
    # @overload createSprite(x, y, shape: shp)
    #  pos: [x, y], size: [shape.width, shape.height]
    #  @param [Numeric] x   x of the sprite position
    #  @param [Numeric] y   y of the sprite position
    #  @param [Shape]   shp shape of the sprite for physics calculations
    #
    # @return [Sprite] the new sprite object
    #
    def createSprite(*args, context: nil, **kwargs)
      context ||= Context.context__
      addSprite Sprite.new(*args, context: context, **kwargs)
    end

    # Adds sprite to the physics engine.
    #
    # @param [Array]  array user array to store the sprite
    # @param [Sprite] sprite sprite object
    #
    # @return [Sprite] the added sprite
    #
    def addSprite(array = nil, sprite)
      @view.add sprite.getInternal__
      array&.push sprite
      sprite
    end

    # Removes sprite from the physics engine.
    #
    # @param [Array]  array user array to remove the sprite
    # @param [Sprite] sprite sprite object
    #
    # @return [Sprite] the removed sprite
    #
    def removeSprite(array = nil, sprite)
      @view.remove sprite.getInternal__
      array&.delete sprite
      sprite
    end

    # Sets gravity for the physics engine.
    #
    # @overload gravity(vec)
    #  @param [Vector] vec gracity vector
    #
    # @overload gravity(ary)
    #  @param [Array<Numeric>] ary gravityX, gravityY
    #
    # @overload gravity(x, y)
    #  @param [Numeric] x x of gravity vector
    #  @param [Numeric] y y of gracity vector
    #
    # @return [nil] nil
    #
    def gravity(*args)
      x, y =
        case arg = args.first
        when Vector then arg.array
        when Array  then arg
        else args
        end
      @view.gravity x, y
      nil
    end

    # Returns the offset of the sprite world.
    #
    # @return [Vector] offset of the sprite world
    #
    def offset()
      s, z = @view.scroll, zoom
      Vector.new s.x / z, s.y / z, s.z / z
    end

    # Sets the offset of the sprite world.
    #
    # @overload offset=(vec)
    #  @param [Vector] vec offset
    #
    # @overload offset=(ary)
    #  @param [Array<Numeric>] ary an array of offsetX and offsetY
    #
    # @return [Vector] offset of the sprite world
    #
    def offset=(arg)
      zoom_   = zoom
      x, y, z =
        case arg
        when Vector then [arg.x,       arg.y,       arg.z]
        when Array  then [arg[0] || 0, arg[1] || 0, arg[2] || 0]
        when nil    then [0,           0,           0]
        else raise ArgumentError
        end
      @view.scroll_to x * zoom_, y * zoom_, z * zoom_
      offset
    end

    # Returns the x-axis offset of the sprite world.
    #
    # @return [Numeric] offset.x
    #
    def ox()
      offset.x
    end

    # Sets the x-axis offset of the sprite world.
    #
    # @param [Numeric] x x-axis offset
    #
    # @return [Numeric] offset.x
    #
    def ox=(x)
      o           = offset
      o.x         = x
      self.offset = o
      x
    end

    # Returns the y-axis offset of the sprite world.
    #
    # @return [Numeric] offset.y
    #
    def oy()
      offset.y
    end

    # Sets the y-axis offset of the sprite world.
    #
    # @param [Numeric] x y-axis offset
    #
    # @return [Numeric] offset.y
    #
    def oy=(x)
      o           = offset
      o.y         = y
      self.offset = o
      y
    end

    # Returns the zoom value of the sprite world.
    #
    # @return [Numeric] zoom
    #
    def zoom()
      @view.zoom
    end

    # Sets the zoom value of the sprite world.
    #
    # @return [Numeric] zoom
    #
    def zoom=(zoom)
      @view.zoom = zoom
    end

    def debug=(state)
      @view.debug = state
    end

    def debug? = @view.debug?

    # @private
    def getInternal__()
      @view
    end

  end# SpriteWorld


  # @private
  class Sprite::View < Reflex::View

    def initialize(sprite, *args, shape:, physics:, **kwargs, &block)
      @sprite = sprite
      super(*args, **kwargs, &block)

      @error            = nil
      @key              = nil
      @keyCode          = nil
      @keyRepeat        = false
      @keysPressed      = nil
      @pointer          = nil
      @pointerPrev      = nil
      @pointersPressed  = []
      @pointersReleased = []
      @touches          = []

      self.shape  = shape.getInternal__ if shape
      self.static = true if physics
    end

    attr_accessor :update,
      :mousePressed, :mouseReleased, :mouseMoved, :mouseDragged, :mouseClicked,
      :touchStarted, :touchEnded, :touchMoved,
      :keyPressed, :keyReleased, :keyTyped,
      :contact, :contactEnd, :willContact

    attr_reader :sprite, :key, :keyCode, :keyRepeat, :touches

    def keysPressed()
      @keysPressed || []
    end

    def mouseX()
      @pointer&.x || 0
    end

    def mouseY()
      @pointer&.y || 0
    end

    def pmouseX()
      @pointerPrev&.x || 0
    end

    def pmouseY()
      @pointerPrev&.y || 0
    end

    def mousePressed?()
      not @pointersPressed.empty?
    end

    def mouseButton()
      ((@pointersPressed + @pointersReleased) & MOUSE_BUTTONS).last
    end

    def clickCount()
      mouseClicked? ? 1 : 0
    end

    def on_update(e)
      callBlock @update
    end

    def on_pointer_down(e)
      updatePointerStates e
      updatePointersPressedAndReleased e, true
      @pointerDownStartPos = to_screen @pointer.pos

      callBlock @mousePressed if e.any? {|p| p.id == @pointer.id}
      callBlock @touchStarted

      e.block
    end

    def on_pointer_up(e)
      updatePointerStates e
      updatePointersPressedAndReleased e, false

      if e.any? {|p| p.id == @pointer.id}
        callBlock @mouseReleased
        callBlock @mouseClicked if mouseClicked?
      end
      callBlock @touchEnded

      @pointerDownStartPos = nil
      @pointersReleased.clear
    end

    def on_pointer_move(e)
      updatePointerStates e

      mouseMoved = e.drag? ? @mouseDragged : @mouseMoved
      callBlock mouseMoved if e.any? {|p| p.id == @pointer.id}
      callBlock @touchMoved
    end

    def on_pointer_cancel(e)
      on_pointer_up e
    end

    def on_key_down(e)
      updateKeyStates e, true
      callBlock @keyPressed
      callBlock @keyTyped if e.chars&.empty? == false
      e.block
    end

    def on_key_up(e)
      updateKeyStates e, false
      callBlock @keyReleased
      e.block
    end

    def on_contact_begin(e)
      return unless @contact
      v = e.view
      callBlock @contact, v.sprite if v.respond_to?(:sprite)
    end

    def on_contact_end(e)
      return unless @contact_end
      v = e.view
      callBlock @contactEnd, v.sprite if v.respond_to?(:sprite)
    end

    def will_contact?(v)
      return true unless @willContact && v.respond_to?(:sprite)
      callBlock @willContact, v.sprite
    end

    private

    MOUSE_BUTTON_MAP = {
      mouse_left:   Processing::GraphicsContext::LEFT,
      mouse_right:  Processing::GraphicsContext::RIGHT,
      mouse_middle: Processing::GraphicsContext::CENTER
    }

    MOUSE_BUTTONS = MOUSE_BUTTON_MAP.values

    def updateKeyStates(event, pressed)
      set        = (@keysPressed ||= Set.new)
      @key       = event.chars
      @keyCode   = event.key
      @keyRepeat = pressed && set.include?(@keyCode)
      pressed ? set.add(@keyCode) : set.delete(@keyCode)
    end

    def updatePointerStates(event)
      pointer = event.find {|p| p.id == @pointer&.id} || event.first
      if !mousePressed? || pointer.id == @pointer&.id
        @pointerPrev, @pointer = @pointer, pointer.dup
      end
      @touches = event.map {|p| Processing::Touch.new(p.id, *p.pos.to_a)}
    end

    def updatePointersPressedAndReleased(event, pressed)
      event.map(&:types).flatten
        .tap {|types| types.delete :mouse}
        .map {|type| MOUSE_BUTTON_MAP[type] || type}
        .each do |type|
          (pressed ? @pointersPressed : @pointersReleased).push type
          if !pressed && index = @pointersPressed.index(type)
            @pointersPressed.delete_at index
          end
        end
    end

    def mouseClicked?()
      return false unless parent && @pointer && @pointerDownStartPos
      [to_screen(@pointer.pos), @pointerDownStartPos]
        .map {|pos| Rays::Point.new pos.x, pos.y, 0}
        .then {|pos, startPos| (pos - startPos).length < 3}
    end

    def callBlock(block, *args)
      block.call(*args) if block && !@error
    rescue Exception => e
      @error = e
      $stderr.puts e.full_message
    end

  end# Sprite::View


  # @private
  class SpriteWorld::View < Reflex::View

    def initialize(*a, pixelsPerMeter: 0, **k, &b)
      create_world pixelsPerMeter if pixelsPerMeter > 0
      super(*a, **k, &b)
      @debug = false
      remove wall
    end

    attr_writer :debug

    def debug? = @debug

    def on_draw(e)
      e.block false unless debug?
    end

  end# SpriteWorld::View


end# RubySketch
