path = File.join(File.dirname(__FILE__), "templates")

puts " Adjusting .gitignore, initializing git repo and creating initial commit ..."
puts "----------------------------------------------------------------------------"
run  "cat #{path}/gitignore >> .gitignore"
git  :init
git  :add => "."
git  :commit => "-am 'Initial commit.'"
puts "----------------------------------------------------------------------------"
