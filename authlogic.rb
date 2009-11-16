require 'open-uri'
  
def download(from, to = from.split("/").last)
  file to, open("http://github.com/thethirdswitch/rails-templates/raw/master/authlogic/#{from}").read
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
 Rails template for installing authlogic gem and scaffolding users / sessions.

 Based on the authlogic example app and password reset logic from 
    http://www.binarylogic.com/2008/11/16/tutorial-reset-passwords-with-authlogic/

 Generated tests assume Shoulda, factory_girl & mocha are present.
 Generated views assume formtastic is present.
 
 IMPORTANT: This template is meant to be run on a fresh app. Some files will be 
            overwritten; and others will be patched using diff / patch (assumes
            this is being run in a *nix environment). See file list below for 
            details.

  * Creates a user migration
  * Creates password reset controller, notifier model and notifier erb template
  * Creates / overwrites user model and unit test
  * Creates / overwrites user controller and functional test
  * Creates stub user views if none already exist
  * Attempts to apply patch to factories.rb; creates it if it doesn't exist
  * Attempts to apply patch to application controller and its functional test
  * Attempts to apply patch to application helper and its functional test
|---------------------------------------------------------------------------------|
CODE

if yes?(ABOUT + "\ncontinue?(y/n)")
  gem "authlogic"

  # User
  generate(:model, "user --skip-migration")
  route "map.resources :users"
  download "create_users.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_create_users.rb"
  download "user.rb", 'app/models/user.rb'
  download "user_test.rb", 'test/unit/user_test.rb'
  download_and_patch "factories.rb", 'test/factories.rb'
  download "users_controller.rb", 'app/controllers/users_controller.rb'
  download "users_controller_test.rb", 'test/functional/users_controller_test.rb'
  run "mkdir app/views/users" if !File.directory?('app/views/users')
  download_and_patch "user.form.html.erb", 'app/views/users/_form.html.erb'
  download_and_patch "user.edit.html.erb", 'app/views/users/edit.html.erb'
  download_and_patch "user.index.html.erb", 'app/views/users/index.html.erb'
  download_and_patch "user.new.html.erb", 'app/views/users/new.html.erb'
  download_and_patch "user.show.html.erb", 'app/views/users/show.html.erb'
  
  # User sessions
  generate(:session, "user_session")
  generate(:controller, "user_sessions")
  route "map.resource :user_session, :only => [:new, :create, :destroy]"
  route "map.root :controller => 'user_sessions', :action => 'new'"
  route 'map.login "login", :controller => "user_sessions", :action => "new"'
  route 'map.logout "logout", :controller => "user_sessions", :action => "destroy"'
  download "user_sessions_controller.rb", 'app/controllers/user_sessions_controller.rb'
  download "user_sessions_controller_test.rb", 'test/functional/user_sessions_controller_test.rb'
  download "sessions.new.html.erb", 'app/views/user_sessions/new.html.erb'

  # Application
  download_and_patch "application_controller.rb", 'app/controllers/application_controller.rb'
  download_and_patch "application_controller_test.rb", 'test/functional/application_controller_test.rb'
  download_and_patch "application_helper.rb", "app/helpers/application_helper.rb"
  download_and_patch "application_helper_test.rb", "test/unit/helpers/application_helper_test.rb"
  
  # Password reset
  generate(:controller, "password_resets")
  route "map.resources :password_resets, :only => [:new, :create, :edit, :update]"
  download "password_resets_controller.rb", 'app/controllers/password_resets_controller.rb'
  download "password_resets_controller_test.rb", 'test/functional/password_resets_controller_test.rb'
  download "notifier.rb", 'app/models/notifier.rb'
  download "notifier_test.rb", 'test/unit/notifier_test.rb'
  download "password_reset_instructions.erb", 'app/views/notifier/password_reset_instructions.erb'
  download "password.edit.html.erb", 'app/views/password_resets/edit.html.erb'
  download "password.new.html.erb", 'app/views/password_resets/new.html.erb'
end