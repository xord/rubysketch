%w[xot rucy beeps rays reflex processing rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch'
using RubySketch

red = green = 0

sprites = (0..10).map do |n|
  createSprite(100 + 50 * n, 100 + 50 * n, 100, 100).tap do |sp|
    name = "sp#{n}"
    sp.instance_variable_set :@n, n
    sp.mousePressed do
      p [name, :pressed, sp.mouseX, sp.mouseY, sp.mouseButton]
    end

    sp.mouseReleased do
      p [name, :released, sp.mouseX, sp.mouseY, sp.mouseButton]
    end

    sp.mouseMoved do
      p [name, :moved, sp.mouseX, sp.mouseY, sp.pmouseX, sp.pmouseY]
    end

    sp.mouseDragged do
      p [name, :dragged, sp.mouseX, sp.mouseY, sp.pmouseX, sp.pmouseY]
    end

    sp.mouseClicked do
      p [name, :clicked, sp.mouseX, sp.mouseY, sp.mouseButton]
      sp.z += 10
    end
  end
end

sprites[1].angle += Math::PI * 0.2
sprites[1].z      = 10

sprites[1].update {red   = (red + 1)   % 255}
sprites[2].update {green = (green + 1) % 255}

sprites[1].draw do |&draw|
  fill red, 200, 200
  draw.call
  fill 0
  text :hello, 10, 20
end

sprites[2].draw do |&draw|
  fill 200, green, 200
  draw.call
  fill 0
  text :world, 10, 20
end

draw do
  background 0
  text sprites.map {|sp| sp.z}, 100, 50
  sprite sprites.sort {|a, b|
    an, bn = [a, b].map {|o| o.instance_variable_get :@n}
    a.z != b.z ? a.z <=> b.z : an <=> bn
  }
end

mousePressed do
  p [:pressed, mouseX, mouseY, mouseButton]
end

mouseReleased do
  p [:released, mouseX, mouseY, mouseButton]
end

mouseMoved do
  p [:moved, mouseX, mouseY, pmouseX, pmouseY]
end

mouseDragged do
  p [:dragged, mouseX, mouseY, pmouseX, pmouseY]
end

mouseClicked do
  p [:clicked, mouseX, mouseY, mouseButton]
end
