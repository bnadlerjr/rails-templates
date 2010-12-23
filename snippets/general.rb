@commands.pre_bundle do
  puts " General App Configuration"
  puts "-------------------------------------------------------------------------"

  remove_file 'README'
  remove_file 'doc/README_FOR_APP'
  remove_file 'public/index.html'
  remove_file 'public/favicon.ico'
  remove_file 'public/images/rails.png'

  run 'touch README'

  if yes?('Would you like to ban spiders from your site? (yes/no)')
    gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
    gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'
  end

  puts "-------------------------------------------------------------------------"
end
