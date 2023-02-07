%w[xot rays reflex processing rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch'
using RubySketch

draw do
  background 0
  textSize 30
  text "hello, rubysketch!", 10, 100
end
