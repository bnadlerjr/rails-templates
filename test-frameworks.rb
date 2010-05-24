root = ENV['LOCATION'] || "~/Dev/rails-templates"
require File.expand_path(File.join(root, "lib/utility"))

about = <<-CODE
\n
|-----------------------------------------------------------------------------|
 Rails template for setting up testing frameworks.

 IMPORTANT: This template will attempt to patch test_helper.rb. It will also 
            remove the test/integration folder and any files in it.
|-----------------------------------------------------------------------------|
CODE

if yes?(about + "\ncontinue?(y/n)")

  run "rm -R test/integration"

  gem "thoughtbot-factory_girl", :lib => "factory_girl", :environment => :test
  gem "thoughtbot-shoulda", :lib => "shoulda", :environment => :test
  gem "autotest-rails", :lib => "autotest/rails", :environment => :test
  gem "cucumber", :environment => :test
  gem "webrat", :environment => :test
  gem "mocha", :environment => :test
  gem "pickle", :environment => :test 
  generate :cucumber
  generate :pickle, 'paths', 'email'

  download_and_patch root, 
    'test-frameworks/test_helper.rb', 'test/test_helper.rb'
end
