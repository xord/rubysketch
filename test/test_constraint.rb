require_relative 'helper'


class TestConstraint < Test::Unit::TestCase

  RS = RubySketch
  PI = Math::PI

  def sprite(*args, **kwargs)
    RS::Sprite.new(*args, **kwargs)
  end

  def vec(*args, **kwargs)
    RS::Vector.new(*args, **kwargs)
  end

  def sprites()
    [sprite(100, 100, 50, 50), sprite(200, 100, 50, 50)]
  end

  def context()
    RS::Context.current__
  end

  def setup()
    @context = RS::Window.new.context
    RS::Context.setCurrent__ @context
  end

  def teardown()
    RS::Context.setCurrent__ nil
  end

  def test_create()
    s1, s2 = sprites

    assert_instance_of RS::SnapConstraint,  s1.snap( s2)
    assert_instance_of RS::LinkConstraint,  s1.link( s2)
    assert_instance_of RS::WheelConstraint, s1.wheel(s2)
    assert_instance_of RS::ChaseConstraint, s1.chase(s2)
  end

  def test_create_by_pin()
    s1, s2 = sprites

    assert_instance_of RS::Pin, s1.pin(10, 20)
    assert_equal s1,            s1.pin(10, 20).sprite
    assert_equal vec(10, 20),   s1.pin(10, 20).pos
    assert_nil                  s1.pin        .pos

    assert_instance_of RS::SnapConstraint, s1.pin(10, 20).snap(s2.pin(30, 40))
    assert_equal [s1, s2],                 s1.pin(10, 20).snap(s2.pin(30, 40)).sprites
  end

  def test_sprites()
    s1, s2 = sprites

    assert_equal [s1, s2],  s1.snap(s2)        .sprites
    assert_equal [s1, nil], s1.link([100, 200]).sprites
  end

  def test_spring_damping_collide()
    s1, s2 = sprites

    assert_in_delta 0,   s1.link(s2,            damping: 0.5, collide: true).spring
    assert_in_delta 4,   s1.link(s2, spring: 4, damping: 0.5, collide: true).spring
    assert_in_delta 0.5, s1.link(s2, spring: 4, damping: 0.5, collide: true).damping
    assert_in_delta 0.5, s1.link(s2, spring: 4, damping: 0.5, collide: true).damping
    assert_false         s1.link(s2, spring: 4, damping: 0.5)               .collide?
    assert_true          s1.link(s2, spring: 4, damping: 0.5, collide: true).collide?

    c = s1.link s2, spring: 4
    c.spring = nil; assert_nil         c.spring
    c.spring = 8;   assert_in_delta 8, c.spring
  end

  def test_force()
    s1, s2 = sprites

    assert_nil           s1.snap(s2)            .force
    assert_in_delta 500, s1.snap(s2, force: 500).force

    c = s1.chase s2, force: 500
    assert_in_delta 500, c.force

    c.force = nil
    assert_nil c.force
  end

  def test_snap_angle_follows_angle_mode()
    s1, s2 = sprites

    c        = s1.snap s2, angle: -PI / 3..PI / 3, motor: PI # RADIANS by default
    internal = c.getInternal__
    assert_in_delta(-60,     internal.angle.begin)
    assert_in_delta( 60,     internal.angle.end)
    assert_in_delta( 180,    internal.motor)
    assert_in_delta(-PI / 3, c.angle.begin)
    assert_in_delta( PI / 3, c.angle.end)
    assert_in_delta( PI,     c.motor)

    c.motor = PI / 2
    assert_in_delta 90, internal.motor

    context.angleMode Processing::GraphicsContext::DEGREES
    c        = s1.snap s2, angle: -60..60, motor: 90
    internal = c.getInternal__
    assert_in_delta(-60, internal.angle.begin)
    assert_in_delta( 60, internal.angle.end)
    assert_in_delta( 90, internal.motor)
    assert_in_delta( 90, c.motor)
  end

  def test_snap_angle_none_or_fixed()
    s1, s2 = sprites

    assert_nil s1.snap(s2).angle

    c = s1.snap s2, angle: 0
    assert_in_delta 0, c.angle.begin
    assert_in_delta 0, c.angle.end
  end

  def test_link_distance_range()
    s1, s2 = sprites

    c = s1.link s2, distance: 80, range: 60..100
    assert_in_delta 80,  c.distance
    assert_in_delta 80,  c.dist
    assert_in_delta 60,  c.range.begin
    assert_in_delta 100, c.range.end
  end

  def test_link_axis()
    s1, s2 = sprites

    assert_nil s1.link(s2).axis # a radial link has no axis

    c = s1.link s2, axis: [0, 1], range: -50..50, motor: 100
    assert_equal    vec(0, 1), c.axis
    assert_in_delta(-50, c.range.begin)
    assert_in_delta( 50, c.range.end)
    assert_in_delta 100, c.getInternal__.motor # linear: not affected by angleMode
    assert_in_delta 100, c.motor

    assert_equal vec(1, 0), s1.link(s2, axis: vec(1, 0)).axis
  end

  def test_wheel()
    s1, s2 = sprites

    c = s1.wheel s2, axis: [0, 1], spring: 6, motor: PI
    assert_equal    vec(0, 1), c.axis
    assert_in_delta 6,   c.spring
    assert_in_delta 180, c.getInternal__.motor # spin motor follows angleMode
    assert_in_delta PI,  c.motor

    assert_equal vec(0, 1), s1.wheel(s2).axis # vertical suspension by default
  end

  def test_chase_target()
    s1, s2 = sprites

    c = s1.chase s2
    assert_equal s2, c.target.sprite

    c.target = [10, 20]
    assert_nil   c.target.sprite
    assert_equal vec(10, 20), c.target.pos

    c.target = vec(30, 40)
    assert_equal vec(30, 40), c.target.pos

    s3       = sprite 300, 100, 50, 50
    c.target = s3
    assert_equal s3, c.target.sprite

    c.target = nil # nil chases nothing: an empty pin with no sprite and no point
    assert_nil c.target.sprite
    assert_nil c.target.pos
  end

  def test_link_current_distance()
    s1, s2 = sprites

    c = s1.link s2
    assert_equal 0, c.currentDistance # 0 while not active in a world

    @context.addSprite s1
    @context.addSprite s2
    s1.dynamic = true
    assert_in_delta 100, c.currentDistance # sprite centers are 100 px apart
  end

  def test_block()
    s1, s2 = sprites

    c = s1.link s2 do
      distance 80
      spring   4
    end
    assert_in_delta 80, c.distance
    assert_in_delta 4,  c.spring

    c = s1.snap s2 do
      motor PI # block form goes through the angleMode conversion too
    end
    assert_in_delta 180, c.getInternal__.motor
  end

  def test_constraints()
    s1, s2 = sprites

    c1 = s1.link s2
    c2 = s1.snap s2
    assert_equal [c1, c2], s1.constraints
    assert_equal [c1, c2], s2.constraints
  end

  def test_remove()
    s1, s2 = sprites

    c = s1.snap s2
    assert_false c.active? # sprites are not in a world yet
    assert_false c.removed?

    c.remove
    assert_true      c.removed?
    assert_equal [], s1.constraints
    assert_equal [], s2.constraints
  end

  def test_constrain_to_itself_error()
    s, = sprites

    assert_raise(ArgumentError) {s.snap  s}
    assert_raise(ArgumentError) {s.chase s}
    assert_equal [], s.constraints
  end

end# TestConstraint
