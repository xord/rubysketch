# rubysketch ChangeLog


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

- depend to processing-0.5.2 gem


## [v0.5.1] - 2023-03-01

- fix bugs


## [v0.5.0] - 2023-02-09

- add Sprite class


## [v0.4.0] - 2023-02-08

- first version
