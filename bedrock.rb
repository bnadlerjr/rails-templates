class Commands
  def initialize
    @pre_bundle = []
    @post_bundle = []
  end

  def pre_bundle(&block)
    @pre_bundle << block
  end

  def post_bundle(&block)
    @post_bundle << block
  end

  def execute(type)
    commands = type == :pre_bundle ? @pre_bundle : @post_bundle
    commands.each { |p| p.call }
  end
end

path = File.join(File.dirname(__FILE__), 'snippets')

# Snippet files will add pre and post bundle commands to this object.
@commands = Commands.new

apply "#{path}/general.rb"
apply "#{path}/rvm.rb"
apply "#{path}/jquery.rb"
apply "#{path}/rspec.rb"
apply "#{path}/cucumber.rb"
apply "#{path}/factory_girl.rb"
apply "#{path}/devise.rb"
apply "#{path}/formtastic.rb"
apply "#{path}/metric_fu.rb"
apply "#{path}/haml.rb"

puts "Executing pre bundle install configuration..."
@commands.execute(:pre_bundle)

puts "Running Bundler install. This could take a moment..."
run  "bundle install"

puts "Executing post bundle install configuration..."
@commands.execute(:post_bundle)

apply "#{path}/git.rb"
