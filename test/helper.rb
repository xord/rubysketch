%w[../xot ../rucy ../beeps ../rays ../reflex ../processing .]
  .map  {|s| File.expand_path "../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'xot/test'
require 'rubysketch/all'

require 'test/unit'

include Xot::Test


def assert_each_in_epsilon(expected, actual, *args)
  expected.zip(actual).each do |e, a|
    assert_in_epsilon e, a, *args
  end
end
