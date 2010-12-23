path = File.join(File.dirname(__FILE__), "templates")

puts " Using Cucumber"
puts "-------------------------------------------------------------------------"
run  "echo \"gem 'cucumber-rails', '>= 0.3.2', :group => [:development, :test]\" >> Gemfile"
run  "echo \"gem 'webrat', '>= 0.7.2', :group => [:development, :test]\" >> Gemfile"
puts "          Running Bundler install. This could take a moment..."
run  "bundle install"
run  "rails generate cucumber:install"
puts "-------------------------------------------------------------------------"
