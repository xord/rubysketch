# RubySketch - A game engine based on the Processing API

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/xord/rubysketch)
![License](https://img.shields.io/github/license/xord/rubysketch)
![Build Status](https://github.com/xord/rubysketch/actions/workflows/test.yml/badge.svg)
![Gem Version](https://badge.fury.io/rb/rubysketch.svg)

## ⚠️  Notice

This repository is a read-only mirror of our monorepo.
We do not accept pull requests or direct contributions here.

### 🔄 Where to Contribute?

All development happens in our [xord/all](https://github.com/xord/all) monorepo, which contains all our main libraries.
If you'd like to contribute, please submit your changes there.

For more details, check out our [Contribution Guidelines](./CONTRIBUTING.md).

Thanks for your support! 🙌

## 🚀 About

**RubySketch** is a 2D game engine for Ruby. It takes the [Processing for CRuby](https://github.com/xord/processing) sketch loop — `setup` / `draw` / `mousePressed` / ... — and layers a game-oriented vocabulary on top of it: `Sprite`, world-based 2D physics (via Box2D), `Sound` and `MML` (Music Macro Language) for audio, animation timers (`animate`, `setInterval`, `setTimeout`), and a small library of easing curves.

## 📋 Requirements

- Ruby **3.0.0** or later
- All the runtime requirements of [Reflex](https://github.com/xord/reflex) (Rays, Rucy, Xot, plus the platform GUI backend — AppKit / UIKit / Win32 / SDL2 — and OpenGL)
- The dependent gems are installed automatically: `xot`, `rucy`, `beeps`, `rays`, `reflexion`, `processing`

There is no native C/C++ extension in this gem; the heavy lifting is done by the underlying gems' extensions.

## 📦 Installation

Add this line to your Gemfile:
```ruby
gem 'rubysketch'
```

Then install:
```bash
$ bundle install
```

Or install it directly:
```bash
$ gem install rubysketch
```

## 📚 What's Provided

`require 'rubysketch'` and `using RubySketch` make the whole **Processing API** ([camelCase](https://github.com/xord/processing#-whats-provided)) plus the RubySketch additions available as top-level methods in your file. As with Processing, a window opens and the sketch runs automatically on file exit; you do not need an explicit `start` call.

`using RubySketch(snake_case: true)` adds snake_case aliases (`create_sprite`, `set_interval`, ...) alongside the camelCase originals.

### On top of Processing, RubySketch adds:

#### Sprites — `RubySketch::Sprite`

`createSprite` returns a `Sprite` whose position, size, angle, velocity, image, offset, pivot, shape, draw block, and per-sprite mouse events you can drive directly.

| Capability                | API                                                                                |
| ------------------------- | ---------------------------------------------------------------------------------- |
| Position / size           | `pos`, `x`, `y`, `z`, `left`, `top`, `right`, `bottom`, `center`, `size`, `width`, `height` |
| Motion                    | `velocity`, `vx`, `vy`, `angle`, `fixAngle`, `pivot`                                |
| Appearance                | `image`, `offset` (texture offset), draw block                                      |
| Physics                   | `dynamic = true`, `static = true`, `restitution`, `density`, `friction`, `shape`    |
| Interaction               | `mousePressed`, `mouseReleased`, `mouseMoved`, `mouseDragged`, `mouseClicked` (per-sprite) |
| Lifecycle                 | `update { ... }`, `draw { ... }`, `show`, `hide`, `capture = true/false`            |

Sprites can be sorted by `z` and drawn in bulk via the top-level `sprite(*sprites)` call.

#### 2D physics

| API                              | Purpose                                              |
| -------------------------------- | ---------------------------------------------------- |
| `gravity(x, y)` / `gravity(vec)` | Set the gravity of the active world                  |
| `Sprite#shape =`                 | Box2D fixture shape (rect, ellipse, polygon)         |

#### Sound

| API                              | Purpose                                              |
| -------------------------------- | ---------------------------------------------------- |
| `loadSound(path)`                | Load a sample (WAV / AIFF / ...) into a `RubySketch::Sound` |
| `Sound#play(gain:)`              | Play; returns a handle exposing `stop`, `playing?`, `seconds` |
| `Sound#stop`                     | Stop all instances                                   |

#### Music Macro Language (MML)

A tiny MML compiler (`RubySketch::MML`) that turns a string like `"t120 l4 cdefgab>c"` into a `RubySketch::Sound`.

- `MML.compile(str, streaming = false)` — compile and return a `Sound` you can play later.
- `MML.play(str)` — shortcut for `compile(str).play`.

#### Animation and timers

| API                                   | Purpose                                                                          |
| ------------------------------------- | -------------------------------------------------------------------------------- |
| `setTimeout(seconds) { ... }`         | Run a block once after a delay; returns an id usable with `clearTimer`           |
| `setInterval(seconds, now:) { ... }`  | Run a block every N seconds                                                      |
| `clearTimer(id)`                      | Cancel a timer                                                                   |
| `animate(seconds, easing:) { ... }`   | Drive a block from 0.0 to 1.0 over time, optionally with an easing curve         |
| `animateValue(seconds, from:, to:, easing:) { ... }` | Same but yields the interpolated value                                 |

Easing names: `linear`, `sineIn` / `sineOut` / `sineInOut`, `quadIn` / ... / `cubicIn` / ..., `expoIn` / `expoOut` / `expoInOut`, `circIn` / ..., `backIn` / `backOut` / `backInOut`, `elasticIn` / `elasticOut` / `elasticInOut`, `bounceIn` / `bounceOut` / `bounceInOut`. See `lib/rubysketch/easings.rb`.

#### MIDI input (forwarded from Reflex)

`notePressed`, `noteReleased`, `controlChange` blocks; `noteNumber`, `noteFrequency`, `noteVelocity`, `controllerIndex`, `controllerValue` accessors during a callback.

#### Miscellaneous

- `vibrate` (mobile)
- `Vector`, `Image`, `WheelEvent` — re-exported from Processing for convenience

## 💡 Usage

### Hello, RubySketch

```ruby
require 'rubysketch'
using RubySketch

draw do
  background 0
  textSize 30
  text 'hello, rubysketch!', 10, 100
end
```

### Sprites and per-sprite input

```ruby
require 'rubysketch'
using RubySketch

player = createSprite 200, 200, 40, 40
player.image = loadImage 'player.png'

player.update do
  player.x += 2 if keyIsDown(RIGHT)
  player.x -= 2 if keyIsDown(LEFT)
end

player.mouseClicked do
  player.z += 10              # bring forward on click
end

draw do
  background 30
  sprite player
end
```

### 2D physics

```ruby
require 'rubysketch'
using RubySketch

noStroke
gravity 0, 1000              # pixels / s^2 downward

ground  = createSprite 0, height - 10, width, 10   # static by default
sprites = []

draw do
  background 100
  sprite ground, *sprites
end

mousePressed do
  sp             = createSprite mouseX + rand, mouseY + rand,
                                shape: Circle.new(0, 0, 20)
  sp.dynamic     = true
  sp.restitution = 0.5
  sprites << sp
end
```

### Sound and MML

```ruby
require 'rubysketch'
using RubySketch

bgm = loadSound 'bgm.wav'

setup do
  bgm.play(gain: 0.6)
end

# play an MML phrase on every click
mousePressed do
  RubySketch::MML.play 't140 l8 ccggaag4 ffeeddc4'
end
```

### Animation with easing

```ruby
require 'rubysketch'
using RubySketch

x = 0
animateValue(2.0, from: 0, to: width, easing: :elasticOut) {|v| x = v }

draw do
  background 0
  fill 1
  ellipse x, height / 2, 40, 40
end
```

See [`examples/`](./examples) for `hello.rb`, `sprite.rb`, `physics.rb`, and `toon.rb`.

## 🛠️ Development

```bash
$ rake test    # run the test suite
$ rake doc     # generate YARD docs
$ rake         # default tasks
```

In the [`xord/all`](https://github.com/xord/all) monorepo you can scope by module, e.g. `rake rubysketch test`.

## 📜 License

**RubySketch** is licensed under the MIT License.
See the [LICENSE](./LICENSE) file for details.
