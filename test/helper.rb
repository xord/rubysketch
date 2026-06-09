%w[../xot ../rucy ../beeps ../rays ../reflex ../processing .]
  .map  {|s| File.expand_path "../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'xot/test'
require 'rubysketch/all'

require 'test/unit'

include Xot::Test


module HasContext

  def new_context()
    RubySketch::Window.new.context
  end

  def setup()
    $processing_context__ = new_context
    super
  end

  def teardown()
    super
    $processing_context__ = nil
  end

  def context()
    $processing_context__
  end

end# HasContext
