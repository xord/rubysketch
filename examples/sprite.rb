%w[xot rucy beeps rays reflex processing rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch'
using RubySketch

sp = createSprite 100, 100, 50, 50
sp.angle += Math::PI * 0.2

red = 0

sp.update do
  red = (red + 1) % 255
end

sp.draw do |&draw|
  fill red, 200, 200
  draw.call
  fill 0
  text :hello, 10, 20
end

sp.mousePressed do
  p [:pressed, sp.mouseX, sp.mouseY, sp.mouseButton]
end

sp.mouseReleased do
  p [:released, sp.mouseX, sp.mouseY, sp.mouseButton]
end

sp.mouseMoved do
  p [:moved, sp.mouseX, sp.mouseY, sp.pmouseX, sp.pmouseY]
end

sp.mouseDragged do
  p [:dragged, sp.mouseX, sp.mouseY, sp.pmouseX, sp.pmouseY]
end

sp.mouseClicked do
  p [:clicked, sp.mouseX, sp.mouseY, sp.mouseButton]
end

draw do
  background 0
  sprite sp
end
