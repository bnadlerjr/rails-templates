@commands.pre_bundle do
  puts " Adding an .rvmrc file"
  puts "-------------------------------------------------------------------------"

  create_file '.rvmrc' do
    version = ask('Which Ruby version?(i.e. "ree" or "1.9.2"')
    "rvm #{version}"
  end

  puts "-------------------------------------------------------------------------"
end
