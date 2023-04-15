# -*- coding: utf-8 -*-


require_relative 'helper'


class TestSound < Test::Unit::TestCase

  RS = RubySketch
  B  = Beeps

  PATH = 'test.wav'

  def sound()
    RS::Sound.load PATH
  end

  def setup()
    B::Sound.new(B::Oscillator.new >> B::Gain.new(gain: 0), 0.1).save PATH
  end

  def teardown()
    B::SoundPlayer.stop_all
    File.delete PATH if File.exist?(PATH)
  end

  def test_play()
    s = sound
    assert_equal [false, false, true],  [s.playing?, s.paused?, s.stopped?]
    s.play
    assert_equal [true,  false, false], [s.playing?, s.paused?, s.stopped?]
  end

  def test_pause()
    s = sound
    s.play
    assert_equal [true,  false, false], [s.playing?, s.paused?, s.stopped?]
    s.pause
    assert_equal [false, true,  false], [s.playing?, s.paused?, s.stopped?]
  end

  def test_stop()
    s = sound
    s.play
    assert_equal [true,  false, false], [s.playing?, s.paused?, s.stopped?]
    s.stop
    assert_equal [false, false, true],  [s.playing?, s.paused?, s.stopped?]
  end

  def test_play_end_then_stop()
    s = sound
    s.play
    assert_equal [true,  false, false], [s.playing?, s.paused?, s.stopped?]
    sleep 0.2
    assert_equal [false, false, true],  [s.playing?, s.paused?, s.stopped?]
  end

  def test_play_after_pause()
    s = sound
    s.play
    s.pause
    assert_equal [false, true,  false], [s.playing?, s.paused?, s.stopped?]
    s.play
    assert_equal [true,  false, false], [s.playing?, s.paused?, s.stopped?]
  end

  def test_stop_after_pause()
    s = sound
    s.play
    s.pause
    assert_equal [false, true,  false], [s.playing?, s.paused?, s.stopped?]
    s.stop
    assert_equal [false, false, true],  [s.playing?, s.paused?, s.stopped?]
  end

  def test_save()
    s = sound

    File.delete PATH
    assert_false File.exist? PATH

    s.save PATH
    assert_true  File.exist? PATH
  end

  def test_load()
    assert_nothing_raised {sound.play}
  end

end# TestSound
