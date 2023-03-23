# -*- coding: utf-8 -*-


%w[../xot ../rucy ../beeps ../rays ../reflex ../processing .]
  .map  {|s| File.expand_path "../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'test/unit'
require 'xot/test'
require 'rubysketch/all'

include Xot::Test
