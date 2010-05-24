root = ENV['LOCATION'] || "~/Dev/rails-templates"
require File.expand_path(File.join(root, "lib/utility"))

about = <<-CODE
\n
|-----------------------------------------------------------------------------|
 Rails template for setting up Capistrano deploy tasks and settings. Assumes
 Capistrano is in the $PATH.
|-----------------------------------------------------------------------------|
CODE

if yes?(about + "\ncontinue?(y/n)")
  run "capify ."
  download root, "capistrano/deploy.rb", "config/deploy.rb"
  download root, "capistrano/staging.rb", "config/deploy/staging.rb"
  download root, "capistrano/production.rb", "config/deploy/production.rb"
end
