path = File.join(File.dirname(__FILE__), "templates")

puts " Using RSpec"
puts "-------------------------------------------------------------------------"
run  "echo \"gem 'rspec-rails', '>= 2.0.0', :group => [:development, :test]\" >> Gemfile"
puts "          Running Bundler install. This could take a moment..."
run  "bundle install"
run  "rails generate rspec:install"
run  "rm -rf test"
puts "-------------------------------------------------------------------------"
