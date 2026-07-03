require_relative 'helper'


class TestSpriteWorld < Test::Unit::TestCase

  RS = RubySketch

  def world(*args, **kwargs)
    RS::SpriteWorld.new(*args, **kwargs)
  end

  def sprite(*args, **kwargs)
    RS::Sprite.new(*args, **kwargs)
  end

  def context()
    RS::Context.current__
  end

  def setup()
    RS::Context.setCurrent__ RS::Window.new.context
  end

  def teardown()
    RS::Context.setCurrent__ nil
  end

  def test_addSprite()
    sprite.tap do |sp|
      w = world
      assert_equal sp,             w    .addSprite(sp)
      assert_not_nil sp.getWorld__
      assert_raise(ArgumentError) {w    .addSprite sp}
      assert_raise(ArgumentError) {world.addSprite sp}
    end

    sprite.tap do |sp|
      w, ary = world, []
      assert_equal sp,             w.addSprite(sp, to: ary)
      assert_equal [sp], ary
    end

    sprite.tap do |sp| # deprecated form
      w, ary = world, []
      assert_equal sp,             w.addSprite(ary, sp)
      assert_equal [sp], ary
    end
  end

  def test_removeSprite()
    sprite.tap do |sp|
      w = world
      assert_raise(ArgumentError) {w.removeSprite sp}
      w.addSprite sp
      assert_equal sp,             w.removeSprite(sp)
      assert_nil sp.getWorld__
    end

    sprite.tap do |sp|
      w, ary = world, []
      w.addSprite sp, to: ary
      assert_equal [sp], ary
      assert_equal sp,             w.removeSprite(sp, from: ary)
      assert_equal [],   ary
    end

    sprite.tap do |sp| # deprecated form
      w, ary = world, []
      w.addSprite ary, sp
      assert_equal [sp], ary
      assert_equal sp,             w.removeSprite(ary, sp)
      assert_equal [],   ary
    end
  end

end# TestSpriteWorld
