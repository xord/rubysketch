%w[xot rucy beeps rays reflex processing rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch'
using RubySketch


class Canvas < Sprite

  def initialize(width, height, scale: 1)
    super 0, 0, width, height

    @width, @height, @scale = width, height, scale
    @images, @frame         = [], 0

    brushSize 1
    brushColor 0, 0, 0, 255

    self.draw do
      drawImage self.image, 0, 0, self.width * self.scale, self.height * self.scale
    end

    self.mousePressed  {brushStarted self.mouseX / self.scale, self.mouseY / self.scale}
    self.mouseReleased {brushEnded   self.mouseX / self.scale, self.mouseY / self.scale}
    self.mouseDragged  {brushMoved   self.mouseX / self.scale, self.mouseY / self.scale}
  end

  attr_reader :width, :height, :scale

  def image()
    @images.insert @frame, createImage(width, height) if @frame >= @images.size
    @images[@frame]
  end

  def play()
    setInterval 0.2, id: :play do
      @frame += 1
      @frame = 0 if @frame >= @images.size
    end
  end

  def stop()
    clearInterval :play
  end

  def nextFrame()
    @frame += 1
  end

  def prevFrame()
    @frame -= 1
    @frame = 0 if @frame < 0
  end

  def brushSize(size)
    @brushSize = size
  end

  def brushColor(r, g, b, a = 255)
    @brushColor = [r, g, b, a]
  end

  def drawPoint(x, y)
    image.beginDraw do |g|
      g.noFill
      g.strokeWeight @brushSize
      g.stroke *@brushColor
      g.point x, y
    end
  end

  def drawLine(x1, y1, x2, y2)
    image.beginDraw do |g|
      g.noFill
      g.strokeWeight @brushSize
      g.stroke *@brushColor
      g.line x1, y1, x2, y2
    end
  end

  def brushStarted(x, y)
    drawPoint x, y
    @prevPoint = [x, y]
  end

  def brushEnded(x, y)
    @prevPoint = nil
  end

  def brushMoved(x, y)
    return unless @prevPoint
    drawLine *@prevPoint, x, y
    @prevPoint = [x, y]
  end

  private

  def createImage(w, h)
    createGraphics(w, h).tap do |g|
      g.beginDraw do
        g.background 255
      end
    end
  end

end# Canvas


class Button < Sprite

  def initialize(label, x = 0, y = 0, w = 100, h = 44, rgb: [200, 200, 200], &block)
    super x, y, w, h

    draw do
      round, offset = 12, 8
      ww, hh        = self.w, self.h - offset
      yy            = mousePressed ? 6 : 0

      fill *rgb.map {_1 - 32}
      rect 0, offset, ww, hh, round

      fill *rgb
      rect 0, yy, ww, hh, round

      textAlign CENTER, CENTER
      fill 0
      text label, 0, yy, ww, hh
    end

    mouseClicked do
      block.call
    end
  end

end# Button


class App

  MARGIN = 10

  def initialize()
    setTitle 'Toon!'
    size 800, 600
    noStroke

    @canvas  = Canvas.new 160, 120, scale: 3
    @buttons = [
      Button.new('Play',      rgb: [240, 180, 180]) {@canvas.play},
      Button.new('Stop',      rgb: [240, 180, 180]) {@canvas.stop},
      Button.new('Next',      rgb: [180, 240, 180]) {@canvas.nextFrame},
      Button.new('Previous',  rgb: [180, 240, 180]) {@canvas.prevFrame},
      Button.new('Brush 1px', rgb: [180, 180, 240]) {@canvas.brushSize 1},
      Button.new('Brush 3px', rgb: [180, 180, 240]) {@canvas.brushSize 3},
      Button.new('Brush 5px', rgb: [180, 180, 240]) {@canvas.brushSize 5},
    ]
    @sprites = [@canvas, *@buttons]
    @sprites.each {addSprite _1}
  end

  def draw()
    background 100
    sprite *@sprites
  end

  def resized()
    @buttons.first.pos = [MARGIN, MARGIN]
    @buttons.each_cons(2) {_2.pos = [MARGIN, _1.bottom + MARGIN]}

    @canvas.pos    = [@buttons.first.right + MARGIN, MARGIN]
    @canvas.right  = windowWidth
    @canvas.bottom = windowHeight
  end

end# App


setup         {$app = App.new}
draw          {$app.draw}
windowResized {$app.resized if $app}
