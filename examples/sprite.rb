%w[xot rucy beeps rays reflex processing rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch'
using RubySketch

red = green = 0

sp1 = createSprite 100, 100, 100, 100
sp2 = createSprite 150, 150, 100, 100

sp1.angle += Math::PI * 0.2

sp1.update do
  red = (red + 1) % 255
end

sp1.draw do |&draw|
  fill red, 200, 200
  draw.call
  fill 0
  text :hello, 10, 20
end

sp1.mousePressed do
  p [:sp1_pressed, sp1.mouseX, sp1.mouseY, sp1.mouseButton]
end

sp1.mouseReleased do
  p [:sp1_released, sp1.mouseX, sp1.mouseY, sp1.mouseButton]
end

sp1.mouseMoved do
  p [:sp1_moved, sp1.mouseX, sp1.mouseY, sp1.pmouseX, sp1.pmouseY]
end

sp1.mouseDragged do
  p [:sp1_dragged, sp1.mouseX, sp1.mouseY, sp1.pmouseX, sp1.pmouseY]
end

sp1.mouseClicked do
  p [:sp1_clicked, sp1.mouseX, sp1.mouseY, sp1.mouseButton]
end

sp2.update do
  green = (green + 1) % 255
end

sp2.draw do |&draw|
  fill 200, green, 200
  draw.call
  fill 0
  text :hello, 10, 20
end

sp2.mousePressed do
  p [:sp2_pressed, sp2.mouseX, sp2.mouseY, sp2.mouseButton]
end

sp2.mouseReleased do
  p [:sp2_released, sp2.mouseX, sp2.mouseY, sp2.mouseButton]
end

sp2.mouseMoved do
  p [:sp2_moved, sp2.mouseX, sp2.mouseY, sp2.pmouseX, sp2.pmouseY]
end

sp2.mouseDragged do
  p [:sp2_dragged, sp2.mouseX, sp2.mouseY, sp2.pmouseX, sp2.pmouseY]
end

sp2.mouseClicked do
  p [:sp2_clicked, sp2.mouseX, sp2.mouseY, sp2.mouseButton]
end

draw do
  background 0
  sprite sp1, sp2
end
