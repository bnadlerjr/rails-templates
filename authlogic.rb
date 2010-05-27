root = ENV['LOCATION'] || "~/Dev/rails-templates"
require File.expand_path(File.join(root, "lib/utility"))

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
  generate(:model, "user --skip-migration --skip-fixture")
  route "map.resources :users"
  download root, "authlogic/create_users.rb", 
    "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_create_users.rb"

  download root, "authlogic/user.rb", 'app/models/user.rb'
  download root, "authlogic/user_test.rb", 'test/unit/user_test.rb'
  download_and_patch root, "authlogic/factories.rb", 'test/factories.rb'
  download root, "authlogic/users_controller.rb", 
    'app/controllers/users_controller.rb'

  download root, "authlogic/users_controller_test.rb", 
    'test/functional/users_controller_test.rb'

  run "mkdir app/views/users" if !File.directory?('app/views/users')
  download_and_patch root, "authlogic/user.form.html.haml", 
    'app/views/users/_form.html.haml'

  download_and_patch root, "authlogic/user.edit.html.haml", 
    'app/views/users/edit.html.haml'

  download_and_patch root, "authlogic/user.index.html.haml", 
    'app/views/users/index.html.haml'

  download_and_patch root, "authlogic/user.new.html.haml", 
    'app/views/users/new.html.haml'

  download_and_patch root, "authlogic/user.show.html.haml", 
    'app/views/users/show.html.haml'
  
  download_and_patch root, "authlogic/custom_steps.rb",
    'features/step_definitions/custom_steps.rb'

  download root, "authlogic/manage_users.feature", 
    "features/manage_users.feature"

  download root, "authlogic/add_user.rake",
    "lib/tasks/user.rake"

  # User sessions
  generate(:session, "user_session")
  generate(:controller, "user_sessions")
  route "map.resource :user_session, :only => [:new, :create, :destroy]"
  route "map.root :controller => 'user_sessions', :action => 'new'"
  route 'map.login "login", :controller => "user_sessions", :action => "new"'
  route 'map.logout "logout", :controller => "user_sessions", :action => "destroy"'

  download root, "authlogic/user_sessions_controller.rb", 
    'app/controllers/user_sessions_controller.rb'

  download root, "authlogic/user_sessions_controller_test.rb", 
    'test/functional/user_sessions_controller_test.rb'

  download root, "authlogic/sessions.new.html.haml", 
    'app/views/user_sessions/new.html.haml'

  download root, "authlogic/login.feature", "features/login.feature"

  # Application
  download_and_patch root, "authlogic/application_controller.rb", 
    'app/controllers/application_controller.rb'

  download_and_patch root, "authlogic/application_controller_test.rb", 
    'test/functional/application_controller_test.rb'

  download_and_patch root, "authlogic/application_helper.rb", 
    "app/helpers/application_helper.rb"

  download_and_patch root, "authlogic/application_helper_test.rb", 
    "test/unit/helpers/application_helper_test.rb"
  
  # Password reset
  generate(:controller, "password_resets")
  route "map.resources :password_resets, :only => [:new, :create, :edit, :update]"

  download root, "authlogic/password_resets_controller.rb", 
    'app/controllers/password_resets_controller.rb'

  download root, "authlogic/password_resets_controller_test.rb", 
    'test/functional/password_resets_controller_test.rb'

  download root, "authlogic/notifier.rb", 'app/models/notifier.rb'
  download root, "authlogic/notifier_test.rb", 'test/unit/notifier_test.rb'
  download root, "authlogic/password_reset_instructions.erb", 
    'app/views/notifier/password_reset_instructions.erb'

  download root, "authlogic/password.edit.html.haml", 
    'app/views/password_resets/edit.html.haml'

  download root, "authlogic/password.new.html.haml", 
    'app/views/password_resets/new.html.haml'

  # Layout
  download root, "authlogic/layout.sessions.html.haml",
    'app/views/layouts/user_sessions.html.haml'

  rake "db:migrate" if yes?("\nRun user migrations?(y/n)")
end
