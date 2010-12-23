path = File.join(File.dirname(__FILE__), "templates")

puts " Adding an .rvmrc file (ruby 1.9.2) "
puts "-------------------------------------------------------------------------"
run  "touch .rvmrc"
run  "cat #{path}/rvmrc >> .rvmrc"
