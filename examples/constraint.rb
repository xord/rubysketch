%w[xot rucy beeps rays reflex processing rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch'
using RubySketch


def setup()
  noStroke
  gravity 0, 1000

  $statics = [
    createSprite(0, height - 10, width, 10),
    createSprite(0,          0, 10, height),
    createSprite(width - 10, 0, 10, height)
  ]
  walls = $statics[1..]
  $balls = []

  # pendulum: snap the hanging ball to the anchor
  pivot  = anchor 100, 100
  weight = ball   170, 100, 30
  pivot.snap weight

  # motored arm: half a turn per second
  hinge = anchor 250, 100
  arm   = ball   250, 140, 20
  hinge.snap arm, motor: PI

  # spring chain: balls linked with springs
  prev = anchor 400, 60
  4.times do |i|
    node = ball 400, 100 + i * 40, 20
    node.link prev, spring: 4, damping: 0.5, collide: true
    prev = node
  end

  # car: each tire rides on the body with a wheel constraint -- a vertical
  # suspension spring and a drive motor, reversed whenever the body bumps
  # into a wall
  body = createSprite 60, height - 80, 60, 14
  body.dynamic = true
  axles = [10, 50].map do |x|
    tire = ball 50 + x, height - 60, 18
    tire.pin(9, 9).wheel body.pin(x, 12),
      axis: [0, 1], spring: 6, damping: 0.7, motor: TWO_PI
  end
  body.contact do |o|
    axles.each {|a| a.motor = -a.motor} if walls.include?(o)
  end
  $car = body

  # chaser: follows the mouse pointer with a soft spring
  chaser = ball 100, 300, 24
  chaser.gravityScale = 0
  chaser.sensor       = true # do not bump the pendulum
  $chase = chaser.chase [100, 300], spring: 2, damping: 0.7
end

def draw()
  background 0

  $chase.target = [mouseX, mouseY]

  fill 200
  sprite *$statics
  fill 240, 240, 240
  sprite $car
  fill 150, 240, 150
  sprite *$balls

  textSize 16
  fill 255, 200, 150
  text "#{frameRate.to_i} FPS - the ball chases the mouse pointer", 20, 30
end

def ball(x, y, size)
  sp = createSprite x, y, shape: Circle.new(0, 0, size)
  sp.dynamic = true
  $balls << sp
  sp
end

def anchor(x, y)
  sp = createSprite x, y, 10, 10 # static by default
  $statics << sp
  sp
end
