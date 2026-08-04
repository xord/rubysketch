# -*- mode: ruby -*-


require_relative 'lib/rubysketch/extension'


Gem::Specification.new do |s|
  glob = -> *patterns do
    patterns.map {|pat| Dir.glob(pat).to_a}.flatten
  end

  ext   = RubySketch::Extension
  name  = ext.name true
  rdocs = glob.call *%w[README]

  s.name        = name
  s.version     = ext.version
  s.license     = 'MIT'
  s.summary     = 'A game engine based on the Processing API.'
  s.description = 'A game engine based on the Processing API.'
  s.authors     = %w[xordog]
  s.email       = 'xordog@gmail.com'
  s.homepage    = "https://github.com/xord/rubysketch"

  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.0.0'

  s.add_dependency 'xot',             '~> 0.4.0'
  s.add_dependency 'rucy',            '~> 0.4.0'
  s.add_dependency 'beeps',           '~> 0.4.0'
  s.add_dependency 'rays',            '~> 0.4.0'
  s.add_dependency 'reflexion',       '~> 0.6.0'
  s.add_dependency 'reflex-packager', '~> 0.2.0'
  s.add_dependency 'processing',      '~> 1.4.0'

  s.files            = `git ls-files`.split $/
  s.executables      = s.files.grep(%r{^bin/}) {|f| File.basename f}
  s.test_files       = s.files.grep %r{^(test|spec|features)/}
  s.extra_rdoc_files = rdocs.to_a
end
