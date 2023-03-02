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


task :clobber => 'pod:clobber'


namespace :pod do
  github  = 'https://github.com/xord'
  renames = {reflexion: 'reflex'}
  regexp  = /add\w+dependency.*['"](\w+)['"].*['"]\s*~>\s*([\d\.]+)\s*['"]/
  repos   = File.readlines('rubysketch.gemspec', chomp: true)
    .map {|s| regexp.match(s)&.values_at 1, 2}
    .compact
    .to_h
    .transform_keys {|name| renames[name.to_sym].then {|s| s || name}}

  task :clobber do
    sh %( rm -rf #{repos.keys.join ' '} )
  end

  task :setup

  repos.each do |repo, ver|
    rakefile = "#{repo}/Rakefile"

    task :setup => rakefile

    file rakefile do
      sh %( git clone --depth 1 --branch v#{ver} #{github}/#{repo} )
      sh %( cd #{repo} && VENDOR_NOCOMPILE=1 rake vendor erb )
    end
  end
end
