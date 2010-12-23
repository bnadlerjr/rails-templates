path = File.join(File.dirname(__FILE__), "templates")

puts " Using HAML & SASS"
puts "-------------------------------------------------------------------------"
run  "echo \"gem 'haml'\" >> Gemfile"
puts "          Running Bundler install. This could take a moment..."
run  "bundle install"
Dir.glob("./app/views/**/*.erb").each do |f|
  puts "Converting #{f} to HAML"
  run "html2haml #{f} #{f.gsub('erb', 'haml')}"
  run "rm #{f}"
end
puts "-------------------------------------------------------------------------"
