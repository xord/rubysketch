# -*- mode: ruby -*-


%w[../xot ../rucy ../beeps ../rays ../reflex ../processing .]
  .map  {|s| File.expand_path "#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rucy/rake'

require 'xot/extension'
require 'rucy/extension'
require 'beeps/extension'
require 'rays/extension'
require 'reflex/extension'
require 'processing/extension'
require 'rubysketch/extension'


EXTENSIONS = [Xot, Rucy, Beeps, Rays, Reflex, Processing, RubySketch]

ENV['RDOC'] = 'yardoc --no-private'

default_tasks
test_ruby_extension
generate_documents
build_ruby_gem
