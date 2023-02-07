# -*- coding: utf-8 -*-


require_relative 'helper'


class TestSprite < Test::Unit::TestCase

  def sprite(*args, **kwargs)
    RubySketch::Sprite.new(*args, **kwargs)
  end

  def vec(*args, **kwargs)
    Processing::Vector.new(*args, **kwargs)
  end

  def test_initialize()
    assert_equal 0,         sprite.x
    assert_equal 0,         sprite.y
    assert_equal vec(0, 0), sprite.pos
  end

end# TestSprite
