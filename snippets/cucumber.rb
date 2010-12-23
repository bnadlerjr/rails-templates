@commands.pre_bundle do
  puts " Using Cucumber"
  puts "-------------------------------------------------------------------------"

  gem  'cucumber-rails', '>= 0.3.2', :group => [:development, :test]
  gem  'webrat', '>= 0.7.2', :group => [:development, :test]
  gem  'pickle', :group => [:development, :test]
end

@commands.post_bundle do
  generate 'cucumber:install'
  generate 'pickle --paths --email'
end
