require File.expand_path(File.join(File.dirname(__FILE__), "../lib/utility"))

about = <<-CODE
\n
|-----------------------------------------------------------------------------|
 Rails template for installing authlogic gem and scaffolding users / sessions.

 Based on the authlogic example app and password reset logic from 
    http://www.binarylogic.com/2008/11/16/tutorial-reset-passwords-with-authlogic/

 Generated tests assume Shoulda, factory_girl & mocha are present.
 Generated views assume formtastic is present.
 
 IMPORTANT: This template is meant to be run on a fresh app. Some files will 
            be overwritten; and others will be patched using diff / patch 
            (assumes this is being run in a *nix environment). See file list 
            below for details.

  * Creates a user migration
  * Creates password reset controller, notifier model and notifier erb template
  * Creates / overwrites user model and unit test
  * Creates / overwrites user controller and functional test
  * Creates stub user views if none already exist
  * Attempts to apply patch to factories.rb; creates it if it doesn't exist
  * Attempts to apply patch to application controller and its functional test
  * Attempts to apply patch to application helper and its functional test
|-----------------------------------------------------------------------------|
CODE

if yes?(about + "\ncontinue?(y/n)")
  gem "authlogic"

  # User
  generate(:model, "user --skip-migration")
  route "map.resources :users"
  download "authlogic/create_users.rb", 
    "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_create_users.rb"

  download "authlogic/user.rb", 'app/models/user.rb'
  download "authlogic/user_test.rb", 'test/unit/user_test.rb'
  download_and_patch "authlogic/factories.rb", 'test/factories.rb'
  download "authlogic/users_controller.rb", 
    'app/controllers/users_controller.rb'

  download "authlogic/users_controller_test.rb", 
    'test/functional/users_controller_test.rb'

  run "mkdir app/views/users" if !File.directory?('app/views/users')
  download_and_patch "authlogic/user.form.html.erb", 
    'app/views/users/_form.html.erb'

  download_and_patch "authlogic/user.edit.html.erb", 
    'app/views/users/edit.html.erb'

  download_and_patch "authlogic/user.index.html.erb", 
    'app/views/users/index.html.erb'

  download_and_patch "authlogic/user.new.html.erb", 
    'app/views/users/new.html.erb'

  download_and_patch "authlogic/user.show.html.erb", 
    'app/views/users/show.html.erb'
  
  # User sessions
  generate(:session, "user_session")
  generate(:controller, "user_sessions")
  route "map.resource :user_session, :only => [:new, :create, :destroy]"
  route "map.root :controller => 'user_sessions', :action => 'new'"
  route 'map.login "login", :controller => "user_sessions", :action => "new"'
  route 'map.logout "logout", :controller => "user_sessions", :action => "destroy"'

  download "authlogic/user_sessions_controller.rb", 
    'app/controllers/user_sessions_controller.rb'

  download "authlogic/user_sessions_controller_test.rb", 
    'test/functional/user_sessions_controller_test.rb'

  download "authlogic/sessions.new.html.erb", 
    'app/views/user_sessions/new.html.erb'

  # Application
  download_and_patch "authlogic/application_controller.rb", 
    'app/controllers/application_controller.rb'

  download_and_patch "authlogic/application_controller_test.rb", 
    'test/functional/application_controller_test.rb'

  download_and_patch "authlogic/application_helper.rb", 
    "app/helpers/application_helper.rb"

  download_and_patch "authlogic/application_helper_test.rb", 
    "test/unit/helpers/application_helper_test.rb"
  
  # Password reset
  generate(:controller, "password_resets")
  route "map.resources :password_resets, :only => [:new, :create, :edit, :update]"

  download "authlogic/password_resets_controller.rb", 
    'app/controllers/password_resets_controller.rb'

  download "authlogic/password_resets_controller_test.rb", 
    'test/functional/password_resets_controller_test.rb'

  download "authlogic/notifier.rb", 'app/models/notifier.rb'
  download "authlogic/notifier_test.rb", 'test/unit/notifier_test.rb'
  download "authlogic/password_reset_instructions.erb", 
    'app/views/notifier/password_reset_instructions.erb'

  download "authlogic/password.edit.html.erb", 
    'app/views/password_resets/edit.html.erb'

  download "authlogic/password.new.html.erb", 
    'app/views/password_resets/new.html.erb'
end
