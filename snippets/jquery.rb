@commands.pre_bundle do
  puts " Using jQuery instead of Prototype.js"
  puts "-------------------------------------------------------------------------"

  gem  'jquery-rails', '>= 0.2.6'
end

@commands.post_bundle do
  generate 'jquery:install'
end
