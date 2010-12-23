@commands.pre_bundle do
  puts " Configuring Devise"
  puts "-------------------------------------------------------------------------"
  gem  'devise'
end

@commands.post_bundle do
  generate 'devise:install'
end
