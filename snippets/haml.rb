@commands.pre_bundle do
  puts " Using HAML & SASS"
  puts "-------------------------------------------------------------------------"

  gem  'haml'
end

@commands.post_bundle do
  Dir.glob("./app/views/**/*.erb").each do |f|
    puts "Converting #{f} to HAML"
    run "html2haml #{f} #{f.gsub('erb', 'haml')}"
    run "rm #{f}"
  end
end
