require 'open-uri'
  
def download(from, to = from.split("/").last)
  file to, open("http://github.com/thethirdswitch/rails-templates/raw/master/test-frameworks/#{from}").read
end

def download_and_patch(from, to)
  if File.exists?(to)
    download(from, "#{to}.new")
    run "diff -Naur #{to} #{to}.new > #{to}.diff"
    run "patch -p0 < #{to}.diff"
    run "rm #{to}.new #{to}.diff"
  else
    download(from, to)
  end
end

ABOUT = <<-CODE
\n
|---------------------------------------------------------------------------------|
 Rails template for setting up testing frameworks.

 IMPORTANT: This template will attempt to patch test_helper.rb. It will also 
            remove the test/integration folder and any files in it.
|---------------------------------------------------------------------------------|
CODE

if yes?(ABOUT + "\ncontinue?(y/n)")

  run "rm -R test/integration"

  gem "thoughtbot-factory_girl", :lib => "factory_girl", :environment => :test
  gem "thoughtbot-shoulda", :lib => "shoulda", :environment => :test
  gem "autotest-rails", :lib => "autotest/rails", :environment => :test
  gem "cucumber", :environment => :test
  gem "webrat", :environment => :test

  generate :cucumber

  download_and_patch 'test_helper.rb', 'test/test_helper.rb'
end