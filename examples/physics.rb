%w[xot rucy beeps rays reflex processing rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch'
using RubySketch

noStroke
gravity 0, 1000

sprites = []
ground  = createSprite 0, height - 10, width, 10

draw do
  background 100
  sprite *sprites, ground
end

mousePressed do
  shape          = Circle.new 0, 0, 20
  sp             = createSprite mouseX + rand, mouseY + rand, shape: shape
  sp.dynamic     = true
  sp.restitution = 0.5
  sprites << sp
end
