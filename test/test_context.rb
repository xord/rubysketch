require_relative 'helper'


class TestContext < Test::Unit::TestCase

  RS = RubySketch

  def world(*args, **kwargs)
    RS::SpriteWorld.new(*args, **kwargs)
  end

  def sprite(*args, **kwargs)
    RS::Sprite.new(*args, **kwargs)
  end

  def context()
    RS::Window.new.context
  end

  def current()
    RS::Context.current__
  end

  def setup()
    RS::Context.setCurrent__ RS::Window.new.context
  end

  def teardown()
    RS::Context.setCurrent__ nil
  end

  def test_addWorld()
    world.tap do |w|
      assert_equal w,              current.addWorld(w)
      assert_equal current, w.getContext__
      assert_raise(ArgumentError) {current.addWorld w}
      assert_raise(ArgumentError) {context.addWorld w}
    end
  end

  def test_removeWorld()
    world.tap do |w|
      assert_raise(ArgumentError) {current.removeWorld w}
      current.addWorld w
      assert_equal w,              current.removeWorld(w)
      assert_nil w.getContext__
    end
  end

  def test_addSprite()
    sprite.tap do |sp|
      assert_equal sp,             current.addSprite(sp)
      assert_not_nil sp.getWorld__
      assert_raise(ArgumentError) {current.addSprite sp}
    end

    sprite.tap do |sp|
      ary = []
      assert_equal sp,             current.addSprite(ary, sp)
      assert_equal [sp], ary
    end
  end

  def test_removeSprite()
    sprite.tap do |sp|
      assert_raise(ArgumentError) {current.removeSprite sp}
      current.addSprite sp
      assert_equal sp,             current.removeSprite(sp)
      assert_nil sp.getWorld__
    end

    sprite.tap do |sp|
      ary = []
      current.addSprite ary, sp
      assert_equal sp,             current.removeSprite(ary, sp)
      assert_equal [], ary
    end
  end

end# TestContext
