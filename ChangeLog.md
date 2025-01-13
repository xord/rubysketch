# rubysketch ChangeLog


## [v0.7.2] - 2025-01-14

- Update workflow files
- Set minumum version for runtime dependency


## [v0.7.1] - 2025-01-13

- Add SpriteWorld class
- addSprite and removeSprite can take many sprites
- Sprite#hide returns self


## [v0.7] - 2024-07-06

- Support Windows


## [v0.6.3] - 2024-07-05

- Update workflows for test
- Update to actions/checkout@v4


## [v0.6.2] - 2024-03-14

- Add 'rexml' to Gemfile


## [v0.6.1] - 2024-03-14

- Update dependencies


## [v0.6] - 2024-03-14

- Depend to processing v1.0


## [v0.5.38] - 2024-02-16

- Update dependencies


## [v0.5.37] - 2024-02-07

- Call noSmooth() by default


## [v0.5.36] - 2024-01-08

- Update dependencies


## [v0.5.35] - 2023-12-09

- Delete poly2tri
- Trigger github actions on all pull_request


## [v0.5.34] - 2023-11-09

- Use Gemfile to install gems for development instead of add_development_dependency in gemspec


## [v0.5.33] - 2023-10-29

- Update dependencies


## [v0.5.32] - 2023-10-29

- Add Shape class
- Add Circle shape class and Sprite can take 'shape' parameter


## [v0.5.31] - 2023-10-25

- Add toon.rb


## [v0.5.30] - 2023-08-24

- Fix failed test


## [v0.5.29] - 2023-08-23

- Add Sprite#contact_end()
- Sprite.new() can take 'physics:' keyword parameter
- Fix that calling clearInterval() inside interval timer block would be ignored


## [v0.5.28] - 2023-07-30

- Update dependencies


## [v0.5.27] - 2023-07-30

- Add vibrate()


## [v0.5.26] - 2023-07-26

- Rescue exceptions thrown at sprite event handlers


## [v0.5.25] - 2023-07-22

- Freeze EASINGS
- Fix that clearTimer() fails clearing timer in very rare cases


## [v0.5.24] - 2023-07-21

- Add animate(), animateValue(), and EASINGS
- Add setTimeout(), setInterval(), and clearTimer() (also aliased as clearTimeout, clearInterval)


## [v0.5.23] - 2023-07-11

- Update dependencies


## [v0.5.22] - 2023-07-11

- Update dependencies


## [v0.5.21] - 2023-07-10

- Sprite#contact block receives only contact begin event
- from_screen() -> fromScreen(), to_screen() -> toScreen()


## [v0.5.20] - 2023-07-09

- Fix that calling mousePressed() without block removes mousePressed block


## [v0.5.19] - 2023-06-27

- Add loadSound() and RubySketch::Sound class


## [v0.5.18] - 2023-06-22

- Update dependencies


## [v0.5.17] - 2023-06-11

- Improve mouse event handling for Sprite class


## [v0.5.16] - 2023-06-08

- Update dependencies


## [v0.5.15] - 2023-06-02

- Update dependencies


## [v0.5.14] - 2023-06-02

- Use WIDTH and HEIGHT env vars for initial canvas size


## [v0.5.13] - 2023-05-29

- Update dependencies


## [v0.5.12] - 2023-05-27

- required_ruby_version >= 3.0.0
- Add spec.license
- Add fixAngle() and angleFixed() to Sprite class


## [v0.5.11] - 2023-05-26

- Add left, top, right, and bottom accessors to Sprite class
- Add show(), hide(), and hidden?() to Sprite class


## [v0.5.10] - 2023-05-21

- Update dependencies


## [v0.5.9] - 2023-05-19

- Add Sprite#clickCount()
- Add Sprite#from_screen() and to_screen()
- Sprite#update returns nil
- Sprite#center includes z


## [v0.5.8] - 2023-05-18

- Dispatch pointer events only to the topmost sprite


## [v0.5.7] - 2023-05-13

- Update dependencies


## [v0.5.6] - 2023-05-11

- Add Sprite#center accessor
- Add Sprite#size=, Sprite#width=, and Sprite#height=


## [v0.5.5] - 2023-05-08

- Add Sprite#draw()
- Add Sprite#angle accessor
- Add Sprite#pivot accessor
- Add Sprite#ox and Sprite#oy
- Add mousePressed, mouseReleased, mouseMoved, mouseDragged, mouseClicked, touchStarted, touchEnded, and touchMoved to Sprite class
- Add inspect() to classes
- Alias draw methods
- Sprite has density 1 by default
- Sprite is static by deault
- Add sprite.rb and physics.rb as an example
- Delete Sound class
- Remove wall collision by default


## [v0.5.4] - 2023-04-30

- Add Sprite#image=() and Sprite#offset=()
- gravity() takes vector by pixel
- Add documents for Sprite class and test it


## [v0.5.3] - 2023-04-22

- Depends on Beeps
- Update RubySketch.podspec to include beeps, rays, reflex, and processing libs
- Add RubySketch.h and RubySketch.mm
- Add Sound class and loadSound()
- Add vx, vy accessors and will_contact? callback to Sprite class
- Add RubySketch::Window andd calls Beeps.process_streams!


## [v0.5.2] - 2023-03-02

- Depend to processing-0.5.2 gem


## [v0.5.1] - 2023-03-01

- Fix bugs


## [v0.5.0] - 2023-02-09

- Add Sprite class


## [v0.4.0] - 2023-02-08

- First version
