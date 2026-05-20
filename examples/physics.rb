%w[xot rucy beeps rays reflex processing rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch'
using RubySketch


def setup()
  noStroke
  gravity 0, 1000

  $sprites = []
  $grounds = [
    createSprite(0, height - 10, width, 10),
    createSprite(0,          0, 10, height),
    createSprite(width - 10, 0, 10, height)
  ]
end

def draw()
  background 0

  fill 200
  sprite *$grounds
  fill 150, 240, 150
  sprite *$sprites

  textSize 16
  fill 255, 200, 150
  text "#{frameRate.to_i} FPS, #{$sprites.size} Shapes", 20, 30
end

def mousePressed()
  $sprites << create(mouseX, mouseY)
end

def mouseDragged()
  $sprites << create(mouseX, mouseY)
end

def create(x, y)
  x   += rand
  y   += rand
  size = 20
  if rand(2) == 0
    sp = createSprite x, y, size, size
  else
    sp = createSprite x, y, shape: Circle.new(0, 0, size)
  end
  sp.dynamic     = true
  sp.restitution = 0.5
  sp
end
