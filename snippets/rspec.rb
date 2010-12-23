@commands.pre_bundle do
  puts " Using RSpec"
  puts "-------------------------------------------------------------------------"

  gem  'rspec-rails', '>= 2.0.0', :group => [:development, :test]
end

@commands.post_bundle do
  generate   'rspec:install'
  remove_dir 'test'
end
