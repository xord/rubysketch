require_relative 'helper'


return if ci? # TODO: fix tests fail on github actions


class TestContext < Test::Unit::TestCase

  RS = RubySketch
  P  = Processing

  def context()
    RS::Context.new P::Window.new
  end

  def sprite(*args, **kwargs)
    RS::Sprite.new(*args, **kwargs)
  end

  def test_addSprite()
    sp = sprite
    assert_nil       context.addSprite()
    assert_equal sp, context.addSprite(sp)
    assert_equal sp, context.addSprite(sp, sprite)
  end

  def test_removeSprite()
    sp = sprite
    assert_nil       context.removeSprite()
    assert_equal sp, context.removeSprite(sp)
    assert_equal sp, context.removeSprite(sp, sprite)
  end

end# TestContext
