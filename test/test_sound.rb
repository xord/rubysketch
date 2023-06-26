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

  def test_play_stop()
    s = sound
    assert_nothing_raised {s.play}
    assert_nothing_raised {s.stop}
  end

end# TestSound
