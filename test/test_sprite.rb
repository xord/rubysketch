require_relative 'helper'


class TestSprite < Test::Unit::TestCase

  RS = RubySketch

  def sprite(*args, **kwargs)
    RS::Sprite.new(*args, **kwargs)
  end

  def vec(*args, **kwargs)
    RS::Vector.new(*args, **kwargs)
  end

  def image(w, h)
    RS::Image.new Rays::Image.new(w, h)
  end

  def test_initialize()
    assert_equal vec(0, 0), sprite            .pos
    assert_equal vec(1, 2), sprite(1, 2)      .pos
    assert_equal vec(1, 2), sprite(1, 2, 3, 4).pos

    assert_equal vec(0, 0), sprite                                .size
    assert_equal vec(3, 4), sprite(1, 2, 3, 4)                    .size
    assert_equal vec(5, 6), sprite(            image: image(5, 6)).size
    assert_equal vec(5, 6), sprite(1, 2,       image: image(5, 6)).size
    assert_equal vec(3, 4), sprite(1, 2, 3, 4, image: image(5, 6)).size

    assert_equal nil,    sprite                    .image
    assert_equal [1, 2], sprite(image: image(1, 2)).image.size

    assert_equal nil,       sprite.offset
    assert_equal vec(1, 2), sprite(offset:    [1, 2]).offset
    assert_equal vec(1, 2), sprite(offset: vec(1, 2)).offset

    assert_raise {sprite 0, 0, -1, 0}
    assert_raise {sprite 0, 0, 0, -1}
  end

  def test_position()
    s = sprite
    assert_equal vec(0, 0), s.pos

    s.pos = vec(1, 2)
    assert_equal vec(1, 2), s.pos

    s.pos = [3, 4]
    assert_equal vec(3, 4), s.pos
  end

  def test_xy()
    s = sprite
    assert_equal     0,     s.x
    assert_equal vec(0, 0), s.pos

    s.x = 1
    assert_equal     1,     s.x
    assert_equal vec(1, 0), s.pos

    s.y = 2
    assert_equal        2,  s.y
    assert_equal vec(1, 2), s.pos
  end

  def test_center()
    s = sprite 0, 0, 10, 20
    assert_equal vec( 5, 10),   s.center

    s.center =   vec 100, 200
    assert_equal vec( 95, 190), s.pos

    s.center =      [300, 400]
    assert_equal vec(295, 390), s.pos
  end

  def test_size()
    assert_equal vec(0, 0), sprite                    .size
    assert_equal vec(1, 0), sprite(0, 0, 1)           .size
    assert_equal vec(1, 2), sprite(0, 0, 1, 2)        .size
    assert_equal vec(3, 4), sprite(image: image(3, 4)).size

    s      = sprite
    s.size =     vec 10, 20
    assert_equal vec(10, 20), s.size

    s.size =        [30, 40]
    assert_equal vec(30, 40), s.size
  end

  def test_wh()
    assert_equal 1, sprite(0, 0, 1, 2).width
    assert_equal 1, sprite(0, 0, 1, 2).w
    assert_equal 2, sprite(0, 0, 1, 2).height
    assert_equal 2, sprite(0, 0, 1, 2).h

    s        = sprite
    s.width  =       10
    assert_equal vec(10, 0),   s.size

    s.w      =       20
    assert_equal vec(20, 0),   s.size

    s.height =            30
    assert_equal vec(200, 30), s.size

    s.h      =            40
    assert_equal vec(200, 40), s.size
  end

  def test_angle()
    s = sprite
    assert_equal 0,             s.angle

    s.angle = Math::PI
    assert_in_epsilon Math::PI, s.angle
  end

  def test_pivot()
    s = sprite
    assert_each_in_epsilon [0, 0],     s.pivot

    s.pivot =              [0.1, 0.2]
    assert_each_in_epsilon [0.1, 0.2], s.pivot
  end

  def test_velocity()
    s = sprite
    assert_equal vec(0, 0), s.vel

    s.vel = vec(1, 2)
    assert_equal vec(1, 2), s.vel

    s.vel = [3, 4]
    assert_equal vec(3, 4), s.vel
  end

  def test_vxvy()
    s = sprite
    assert_equal     0,     s.vx
    assert_equal vec(0, 0), s.vel

    s.vx = 1
    assert_equal     1,     s.vx
    assert_equal vec(1, 0), s.vel

    s.vy = 2
    assert_equal        2,  s.vy
    assert_equal vec(1, 2), s.vel
  end

  def test_image()
    s = sprite
    assert_equal nil,    s.image

    s.image = image(1, 2)
    assert_equal [1, 2], s.image.size

    s.image = image(3, 4)
    assert_equal [3, 4], s.image.size

    s.image = nil
    assert_equal nil,    s.image
  end

  def test_offset()
    s = sprite
    assert_equal nil,       s.offset

    s.offset =      [1, 2]
    assert_equal vec(1, 2), s.offset

    s.offset =   vec(3, 4)
    assert_equal vec(3, 4), s.offset

    s.offset =      [5]
    assert_equal vec(5, 0), s.offset

    s.offset =      []
    assert_equal vec(0, 0), s.offset

    s.offset =   nil
    assert_equal nil,       s.offset

    assert_raise(ArgumentError) {s.offset = 1}
  end

  def test_oxoy()
    s = sprite
    assert_equal    [0, 0], [s.ox, s.oy]
    assert_equal    nil,    s.offset

    s.ox = 1
    assert_equal    [1, 0], [s.ox, s.oy]
    assert_equal vec(1, 0), s.offset

    s = sprite

    s.oy = 2
    assert_equal    [0, 2], [s.ox, s.oy]
    assert_equal vec(0, 2), s.offset

    s.offset = nil
    assert_equal    [0, 0], [s.ox, s.oy]
    assert_equal    nil,    s.offset
  end

  def test_dynamic?()
    s = sprite
    assert_equal false, s.dynamic?

    s.dynamic = true
    assert_equal true,  s.dynamic?

    s.dynamic = false
    assert_equal false, s.dynamic?
  end

  def test_density()
    s = sprite
    assert_equal 1, s.dens

    s.dens = 2
    assert_equal 2, s.dens
  end

  def test_friction()
    s = sprite
    assert_equal 0, s.fric

    s.fric = 1
    assert_equal 1, s.fric
  end

  def test_restitution()
    s = sprite
    assert_equal 0, s.rest

    s.rest = 1
    assert_equal 1, s.rest
  end

  def test_blocks()
    s = sprite
    v = s.instance_variable_get :@view__
    assert_nil v.update
    assert_nil v.contact
    assert_nil v.will_contact

    s.update {}
    assert_not_nil v.update
    assert_nil     v.contact
    assert_nil     v.will_contact

    s.contact {}
    assert_not_nil v.update
    assert_not_nil v.contact
    assert_nil     v.will_contact

    s.contact? {}
    assert_not_nil v.update
    assert_not_nil v.contact
    assert_not_nil v.will_contact
  end

  def test_inspect()
    assert_match %r|#<RubySketch::Sprite:0x\w{16}>|, sprite.inspect
  end

end# TestSprite
