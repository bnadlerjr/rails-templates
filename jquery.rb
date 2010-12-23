path = File.join(File.dirname(__FILE__), "templates")

puts " Using jQuery instead of Prototype.js"
puts "-------------------------------------------------------------------------"
run  "echo \"gem 'jquery-rails', '>= 0.2.6'\" >> Gemfile"
puts "          Running Bundler install. This could take a moment..."
run  "bundle install"
run  "rails generate jquery:install"
puts "-------------------------------------------------------------------------"
