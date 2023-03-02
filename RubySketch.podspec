# -*- mode: ruby -*-


Pod::Spec.new do |s|
  s.name         = "RubySketch"
  s.version      = File.read(File.expand_path 'VERSION', __dir__)[/[\d\.]+/]
  s.summary      = "A game engine based on the Processing API"
  s.description  = "A game engine based on the Processing API"
  s.license      = "MIT"
  s.source       = {:git => "https://github.com/xord/rubysketch.git"}
  s.author       = {"xordog" => "xordog@gmail.com"}
  s.homepage     = "https://github.com/xord/rubysketch"

  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = "10.0"

  incdirs = %W[
    #{s.name}/src
    CRuby/CRuby/include
    Reflexion/reflex/include
    RubyProcessing/src
  ].map {|s| "${PODS_ROOT}/#{s}"}

  s.prepare_command = 'rake pod:setup'
  s.preserve_paths  = "src"
  s.source_files    = "src/*.mm"
  s.xcconfig        = {"HEADER_SEARCH_PATHS" => incdirs.join(' ')}

  s.resource_bundles = {'RubySketch' => %w[lib VERSION]}
end
