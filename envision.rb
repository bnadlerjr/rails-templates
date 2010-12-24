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

paths = {
  :root      => File.dirname(__FILE__),
  :snippet   => File.join(File.dirname(__FILE__), 'snippets'),
  :templates => File.join(File.dirname(__FILE__), 'templates'),
}

# Snippet files will add pre and post bundle commands to this object.
@commands = Commands.new

apply "#{paths[:snippet]}/general.rb"
apply "#{paths[:snippet]}/rvm.rb"
apply "#{paths[:snippet]}/jquery.rb"
apply "#{paths[:snippet]}/rspec.rb"
apply "#{paths[:snippet]}/cucumber.rb"
apply "#{paths[:snippet]}/factory_girl.rb"
apply "#{paths[:snippet]}/devise.rb"
apply "#{paths[:snippet]}/formtastic.rb"
apply "#{paths[:snippet]}/metric_fu.rb"
apply "#{paths[:snippet]}/haml.rb"

puts "Copying template files..."
copy_file "#{paths[:templates]}/envision/application.html.erb",
          "app/views/layouts/application.html.erb"

puts "Executing pre bundle install configuration..."
@commands.execute(:pre_bundle)

puts "Running Bundler install. This could take a moment..."
run  "bundle install"

puts "Executing post bundle install configuration..."
@commands.execute(:post_bundle)

apply "#{paths[:snippet]}/git.rb"
