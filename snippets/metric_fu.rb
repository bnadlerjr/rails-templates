@commands.pre_bundle do
  puts " Configuring metric_fu"
  puts "-------------------------------------------------------------------------"

  gem  'metric_fu'
end
