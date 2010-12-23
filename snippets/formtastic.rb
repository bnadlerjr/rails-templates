@commands.pre_bundle do
  puts " Configuring Formtastic"
  puts "-------------------------------------------------------------------------"

  gem  'formtastic', '~> 1.1.0'
end

@commands.post_bundle do
  generate 'formtastic:install'
end
