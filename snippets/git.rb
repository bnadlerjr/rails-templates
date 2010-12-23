IGNORE = %w[.DS_Store *.swp .rvmrc doc/coverage]

puts " Adjusting .gitignore, initializing git repo and creating initial commit ..."
puts "-------------------------------------------------------------------------"

append_file '.gitignore', IGNORE.join("\n")

git  :init
git  :add => "."
git  :commit => "-am 'Initial commit.'"

puts "-------------------------------------------------------------------------"
