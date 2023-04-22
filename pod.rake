# -*- mode: ruby -*-


version = File.readlines('VERSION', chomp: true).first
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

repos.merge('rubysketch' => version).each do |repo, ver|
  rakefile = "#{repo}/Rakefile"
  opts     = {
    depth:  1,
    branch: (ENV['RUBYSKETCH_BRANCH'] || "v#{ver}")
  }.map {|k, v| "--#{k} #{v}"}.join ' '

  task :setup => rakefile

  file rakefile do
    sh %( git clone #{opts} #{github}/#{repo} )
    sh %( cd #{repo} && VENDOR_NOCOMPILE=1 rake vendor erb )
  end
end
