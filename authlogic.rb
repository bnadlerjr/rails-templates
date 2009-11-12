require 'open-uri'
template_root = "http://github.com/thethirdswitch/rails-templates/raw/master/authlogic"
  
def download(from, to = from.split("/").last)
  file to, open(from).read
rescue Exception => e
  puts e.inspect
  exit!
end

def download_and_patch(from, to)
  if !File.exists?(to)
    download(from, "#{to}.new")
    run "diff #{to} #{to}.new > #{to}.diff"
    run "patch -p0 < #{to}.diff"
    run "rm #{to}.new #{to}.diff"
  else
    download(from, to)
  end
end

ABOUT = <<-CODE
\n
|---------------------------------------------------------------------------------|
 Rails template for installing authlogic gem and scaffolding users / sessions.

 Based on the authlogic example app and password reset logic from 
    http://www.binarylogic.com/2008/11/16/tutorial-reset-passwords-with-authlogic/

 Generated tests assume Shoulda and factory_girl are present.

 IMPORTANT: This template is meant to be run on a fresh app. Some files will be 
            overwritten; and others will be patched using diff / patch (assumes
            this is being run in a *nix environment). See file list below for 
            details.

  * Creates a user migration
  * Creates password reset controller, notifier model and notifier erb template
  * Creates / overwrites user model and unit test
  * Creates / overwrites user controller and functional test
  * Attempts to apply patch to factories.rb; creates it if it doesn't exist
  * Attempts to apply patch to application_controller.rb
|---------------------------------------------------------------------------------|
CODE

if yes?(ABOUT + "\ncontinue?(y/n)")
  gem "authlogic"

  generate(:model, "user --skip-migration")
  route "map.resources :users"
  download "#{template_root}/create_users.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_create_users.rb"
  download "#{template_root}/user.rb", 'app/models/user.rb'
  download "#{template_root}/user_test.rb", 'test/unit/user_test.rb'
  download_and_patch "#{template_root}/factories.rb", 'test/unit/factories.rb'
  download "#{template_root}/users_controller.rb", 'app/controllers/users_controller.rb'
    
  generate(:session, "user_session")
  generate(:controller, "user_sessions")
  route "map.resource :user_session, :only => [:new, :create, :destroy]"
  route "map.root :controller => 'user_sessions', :action => 'new'"
  download "#{template_root}/user_sessions_controller.rb", 'app/controllers/user_sessions_controller.rb'
  file 'app/views/user_sessions/new.html.erb', "<p>Placeholder for new.html.erb</p>"
  download "#{template_root}/user_sessions_controller_test.rb", 'test/functional/user_sessions_controller_test.rb'

  download_and_patch "#{template_root}/application_controller.rb", 'app/controllers/application_controller.rb'

  generate(:controller, "password_resets")
  download "#{template_root}/password_resets_controller.rb", 'app/controllers/password_resets_controller.rb'
  download "#{template_root}/notifier.rb", 'app/models/notifier.rb'
  download "#{template_root}/password_reset_instructions.erb", 'app/views/notifier/password_reset_instructions.erb'
end