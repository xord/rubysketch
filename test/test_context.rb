require_relative 'helper'


class TestContext < Test::Unit::TestCase

  include HasContext

  RS = RubySketch

  def world(*args, **kwargs)
    RS::SpriteWorld.new(*args, **kwargs)
  end

  def sprite(*args, **kwargs)
    RS::Sprite.new(*args, **kwargs)
  end

  def test_addWorld()
    world.tap do |w|
      assert_equal w,                  context.addWorld(w)
      assert_equal context, w.getContext__
      assert_raise(ArgumentError)     {context.addWorld w}
      assert_raise(ArgumentError) {new_context.addWorld w}
    end
  end

  def test_removeWorld()
    world.tap do |w|
      assert_raise(ArgumentError) {context.removeWorld w}
      context.addWorld w
      assert_equal w,              context.removeWorld(w)
      assert_nil w.getContext__
    end
  end

  def test_addSprite()
    sprite.tap do |sp|
      assert_equal sp,             context.addSprite(sp)
      assert_not_nil sp.getWorld__
      assert_raise(ArgumentError) {context.addSprite sp}
    end

    sprite.tap do |sp|
      ary = []
      assert_equal sp,             context.addSprite(sp, to: ary)
      assert_equal [sp], ary
    end

    sprite.tap do |sp| # deprecated form
      ary = []
      assert_equal sp,             context.addSprite(ary, sp)
      assert_equal [sp], ary
    end
  end

  def test_removeSprite()
    sprite.tap do |sp|
      assert_raise(ArgumentError) {context.removeSprite sp}
      context.addSprite sp
      assert_equal sp,             context.removeSprite(sp)
      assert_nil sp.getWorld__
    end

    sprite.tap do |sp|
      ary = []
      context.addSprite sp, to: ary
      assert_equal sp,             context.removeSprite(sp, from: ary)
      assert_equal [], ary
    end

    sprite.tap do |sp| # deprecated form
      ary = []
      context.addSprite ary, sp
      assert_equal sp,             context.removeSprite(ary, sp)
      assert_equal [], ary
    end
  end

end# TestContext
