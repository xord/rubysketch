module RubySketch


  # Constrains the motion of sprites.
  # Constraints are created with Sprite#snap, #link, #wheel and #chase
  # (or the same verbs on Sprite#pin), not with new.
  #
  class Constraint

    include Xot::Setter

    # @private
    def initialize(constraint)
      @constraint__ = constraint
    end

    # Removes the constraint permanently.
    #
    # @return [Constraint] self
    #
    def remove()
      @constraint__.remove
      self
    end

    # Sets the spring stiffness in hertz.
    #
    # @param [Numeric, nil] hertz stiffness, or nil to make it rigid
    #
    # @return [Numeric, nil] hertz
    #
    def spring=(hertz)
      @constraint__.spring = hertz
    end

    # Returns the spring stiffness in hertz.
    #
    # @return [Numeric, nil] hertz, or nil if the constraint is rigid
    #
    def spring()
      @constraint__.spring
    end

    # Sets the spring damping ratio.
    #
    # @param [Numeric] ratio 0 (no damping) to 1 (critical damping)
    #
    # @return [Numeric] damping ratio
    #
    def damping=(ratio)
      @constraint__.damping = ratio
    end

    # Returns the spring damping ratio.
    #
    # @return [Numeric] damping ratio
    #
    def damping()
      @constraint__.damping
    end

    # Sets whether the constrained sprites collide with each other.
    #
    # @param [Boolean] bool collide or not
    #
    # @return [Boolean] collide or not
    #
    def collide=(bool)
      @constraint__.collide = bool
    end

    # Returns whether the constrained sprites collide with each other.
    #
    # @return [Boolean] collide or not
    #
    def collide?()
      @constraint__.collide?
    end

    # Sets the maximum force (or torque) that drives the constraint.
    #
    # @param [Numeric, nil] force
    #  maximum force, or nil for the default strength.
    #  0 makes the drive powerless
    #
    # @return [Numeric, nil] force
    #
    def force=(force)
      @constraint__.force = force
    end

    # Returns the maximum force that drives the constraint.
    #
    # @return [Numeric, nil] force, or nil for the default strength
    #
    def force()
      @constraint__.force
    end

    universal_accessor :spring, :damping, :force, collide: {reader: :collide?}

    # Returns whether the constraint is active in a physics world.
    #
    # @return [Boolean] active or not
    #
    def active?()
      @constraint__.active?
    end

    # Returns whether the constraint was removed.
    #
    # @return [Boolean] removed or not
    #
    def removed?()
      @constraint__.removed?
    end

    # Returns the sprites the constraint is fastened to.
    #
    # @return [Array<Sprite, nil>] nil for a world anchor
    #
    def sprites()
      @sprites__ ||= @constraint__.views.map {_1&.sprite}.freeze
    end

    # @private
    def ==(o)
      o.is_a?(Constraint) && @constraint__ == o.getInternal__
    end

    alias eql? ==

    # @private
    def hash()
      @constraint__.hash
    end

    # @private
    def getInternal__()
      @constraint__
    end

    # @private
    def self.wrap__(constraint)
      klass =
        case constraint
        when Reflex::SnapConstraint  then SnapConstraint
        when Reflex::LinkConstraint  then LinkConstraint
        when Reflex::WheelConstraint then WheelConstraint
        when Reflex::ChaseConstraint then ChaseConstraint
        else raise ArgumentError, "unknown constraint type: #{constraint.class}"
        end
      klass.new constraint
    end

    private

    def getContext__()
      sprites.first&.getContext__ || Processing.context
    end

    def toDegrees__(angle)
      getContext__.toDegrees__ angle
    end

    def fromDegrees__(degrees)
      getContext__.fromDegrees__ degrees
    end

  end# Constraint


  # Snaps two points together like a hinge.
  #
  class SnapConstraint < Constraint

    # Sets the range of the relative rotation angle.
    #
    # @param [Range, Numeric, nil] angle
    #  radians or degrees depending on angleMode().
    #  nil rotates freely, 0 fixes the rotation
    #
    # @return [Range, Numeric, nil] angle
    #
    def angle=(angle)
      @constraint__.angle =
        case angle
        when Range   then Range.new toDegrees__(angle.begin), toDegrees__(angle.end)
        when Numeric then toDegrees__ angle
        else              angle
        end
    end

    # Returns the range of the relative rotation angle.
    #
    # @return [Range, nil] radians or degrees depending on angleMode()
    #
    def angle()
      angle = @constraint__.angle
      angle ? Range.new(fromDegrees__(angle.begin), fromDegrees__(angle.end)) : nil
    end

    # Sets the motor speed that drives the relative rotation.
    #
    # @param [Numeric, nil] speed
    #  angular velocity per second, radians or degrees depending on
    #  angleMode(). nil stops the motor
    #
    # @return [Numeric, nil] speed
    #
    def motor=(speed)
      @constraint__.motor = speed && toDegrees__(speed)
    end

    # Returns the motor speed.
    #
    # @return [Numeric, nil] angular velocity per second
    #
    def motor()
      speed = @constraint__.motor
      speed && fromDegrees__(speed)
    end

    universal_accessor :angle, :motor

  end# SnapConstraint


  # Keeps two points apart at a distance, or slides them along an axis
  # like a rail.
  #
  class LinkConstraint < Constraint

    # Sets the axis to slide along.
    # With an axis, the separation is measured along it instead of
    # radially, and the relative rotation is locked like a rail.
    #
    # @param [Vector, Array<Numeric>, nil] axis
    #  direction in the target local space, or nil to link radially
    #
    # @return [Vector, Array<Numeric>, nil] axis
    #
    def axis=(axis)
      @constraint__.axis = RubySketch.unwrap__ axis
    end

    # Returns the axis to slide along.
    #
    # @return [Vector, nil] axis, or nil for a radial link
    #
    def axis()
      @constraint__.axis&.toVector
    end

    # Sets the distance to keep.
    #
    # @param [Numeric] distance distance in pixels
    #
    # @return [Numeric] distance
    #
    def distance=(distance)
      @constraint__.distance = distance
    end

    # Returns the distance to keep.
    #
    # @return [Numeric] distance in pixels
    #
    def distance()
      @constraint__.distance
    end

    # Returns the current distance between the two points.
    #
    # @return [Numeric] distance in pixels, or 0 if not active in a world
    #
    def currentDistance()
      @constraint__.current_distance
    end

    # Sets the range of the separation.
    #
    # @param [Range, Numeric, nil] range
    #  distance range like a rope, or the translation range along the axis
    #
    # @return [Range, Numeric, nil] range
    #
    def range=(range)
      @constraint__.range = range
    end

    # Returns the range of the separation.
    #
    # @return [Range, nil] separation range
    #
    def range()
      @constraint__.range
    end

    # Sets the motor speed that drives the separation.
    #
    # @param [Numeric, nil] speed speed in pixels per second, or nil to stop
    #
    # @return [Numeric, nil] speed
    #
    def motor=(speed)
      @constraint__.motor = speed
    end

    # Returns the motor speed.
    #
    # @return [Numeric, nil] speed in pixels per second
    #
    def motor()
      @constraint__.motor
    end

    universal_accessor :axis, :distance, :range, :motor

    alias dist= distance=
    alias dist  distance

  end# LinkConstraint


  # Rides on the target like a wheel: slides along an axis for the
  # suspension while spinning freely.
  #
  class WheelConstraint < Constraint

    # Sets the axis to slide along for the suspension.
    #
    # @param [Vector, Array<Numeric>] axis direction in the target local space
    #
    # @return [Vector, Array<Numeric>] axis
    #
    def axis=(axis)
      @constraint__.axis = RubySketch.unwrap__ axis
    end

    # Returns the axis to slide along.
    #
    # @return [Vector] axis
    #
    def axis()
      @constraint__.axis&.toVector
    end

    # Sets the range of the translation along the axis.
    #
    # @param [Range, Numeric, nil] range translation range in pixels
    #
    # @return [Range, Numeric, nil] range
    #
    def range=(range)
      @constraint__.range = range
    end

    # Returns the range of the translation along the axis.
    #
    # @return [Range, nil] translation range
    #
    def range()
      @constraint__.range
    end

    # Sets the motor speed that spins the wheel.
    #
    # @param [Numeric, nil] speed
    #  angular velocity per second, radians or degrees depending on
    #  angleMode(). nil stops the motor
    #
    # @return [Numeric, nil] speed
    #
    def motor=(speed)
      @constraint__.motor = speed && toDegrees__(speed)
    end

    # Returns the motor speed.
    #
    # @return [Numeric, nil] angular velocity per second
    #
    def motor()
      speed = @constraint__.motor
      speed && fromDegrees__(speed)
    end

    universal_accessor :axis, :range, :motor

  end# WheelConstraint


  # Moves a point toward the target every frame.
  #
  class ChaseConstraint < Constraint

    # Sets the target to chase.
    #
    # @param [Sprite, Pin, Vector, Array<Numeric>, nil] target
    #  the center of a sprite, a pin, or a point in the world.
    #  nil chases nothing
    #
    # @return [Sprite, Pin, Vector, Array<Numeric>, nil] target
    #
    def target=(target)
      @constraint__.target = RubySketch.unwrap__ target
    end

    # Returns the target to chase.
    #
    # @return [Pin] the target pin
    #
    def target()
      Pin.new nil, pin__: @constraint__.target
    end

    universal_accessor :target

  end# ChaseConstraint


end# RubySketch
