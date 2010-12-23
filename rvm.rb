path = File.join(File.dirname(__FILE__), "templates")

puts " Adding an .rvmrc file (ruby 1.9.2) "
puts "-------------------------------------------------------------------------"
run  "touch .rvmrc"
run  "echo 'rvm 1.9.2' >> .rvmrc"
puts "-------------------------------------------------------------------------"
