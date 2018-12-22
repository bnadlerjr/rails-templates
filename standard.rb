source_paths.unshift(File.join(File.dirname(__FILE__), 'lib', 'templates'))
template 'Gemfile.tt', force: true
template 'README.md.tt', force: true
remove_file 'README.rdoc'
template 'example.env.tt'
copy_file 'gitignore', '.gitignore', force: true
copy_file 'Procfile'
copy_file 'bin/setup', force: true
chmod 'bin/setup', '+x'
copy_file 'bin/update', force: true
chmod 'bin/update', '+x'
template 'database.yml.tt', 'config/database.yml', force: true
copy_file 'puma.rb.tt', 'config/puma.rb', force: true
copy_file 'generators.rb.tt', 'config/initializers/generators.rb'
copy_file 'rotate_log.rb.tt', 'config/initializers/rotate_log.rb'
copy_file 'application.scss.tt', 'app/assets/stylesheets/application.scss'
copy_file 'application.js.tt', 'app/assets/javascripts/application.js', force: true
remove_file 'app/assets/stylesheets/application.css'
remove_dir 'test'

gsub_file 'config/initializers/filter_parameter_logging.rb', /\[:password\]/ do
  '%w(password secret session cookie csrf)'
end

mailer_regex = /config\.action_mailer\.raise_delivery_errors = false\n/
comment_lines 'config/environments/development.rb', mailer_regex
insert_into_file 'config/environments/development.rb', after: mailer_regex do
  <<-RUBY

  # Ensure mailer works in development.
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.asset_host = 'http://localhost:3000'

  config.after_initialize do
    Bullet.enable = true
    Bullet.console = true
    Bullet.rails_logger = true
  end
  RUBY
end

uncomment_lines 'config/environments/production.rb', /config\.force_ssl = true/

gsub_file 'config/environments/test.rb',
          'config.eager_load = false',
          'config.eager_load = defined?(SimpleCov).present?'

insert_into_file \
  'config/environments/test.rb',
  after: /config\.action_mailer\.delivery_method = :test\n/ do

  <<-RUBY
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.asset_host = 'http://localhost:3000'
  RUBY
end

after_bundle do
  run 'spring stop'
  generate 'rspec:install'
  prepend_to_file 'spec/spec_helper.rb' do
    <<-RUBY
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/'
end
puts 'REQUIRED SIMPLECOV'

RUBY
  end
  gsub_file 'spec/spec_helper.rb', '=begin', 'begin'
  gsub_file 'spec/spec_helper.rb', '=end', 'end'
  gsub_file 'spec/rails_helper.rb', /  # Remove this line.*/, ''
  gsub_file 'spec/rails_helper.rb', /config\.fixture_path.*/, 'config.include FactoryBot::Syntax::Methods'
  gsub_file 'spec/rails_helper.rb', /\# Add additional requires.*/, "require 'clearance/rspec'"
  run 'bundle binstubs rspec-core'
  generate 'clearance:install'
  generate 'clearance:routes'
  generate 'clearance:specs'
  run 'bundle exec rake db:migrate'
  copy_file 'application.html.erb.tt', 'app/views/layouts/application.html.erb', force: true
  copy_file 'site.html.erb.tt', 'app/views/layouts/site.html.erb', force: true
  copy_file 'views/users/new.html.erb.tt', 'app/views/users/new.html.erb', force: true
  copy_file 'views/sessions/new.html.erb.tt', 'app/views/sessions/new.html.erb', force: true
  copy_file 'views/dashboard/index.html.erb.tt', 'app/views/dashboard/index.html.erb', force: true
  copy_file 'views/passwords/new.html.erb.tt', 'app/views/passwords/new.html.erb', force: true
  copy_file 'views/passwords/edit.html.erb.tt', 'app/views/passwords/edit.html.erb', force: true
  copy_file 'views/passwords/create.html.erb.tt', 'app/views/passwords/create.html.erb', force: true
  copy_file 'views/shared/_content.html.erb.tt', 'app/views/shared/_content.html.erb', force: true
  copy_file 'views/shared/_user_menu.html.erb.tt', 'app/views/shared/_user_menu.html.erb', force: true
  copy_file 'views/shared/_footer.html.erb.tt', 'app/views/shared/_footer.html.erb', force: true
  copy_file 'controllers/dashboard_controller.rb.tt', 'app/controllers/dashboard_controller.rb', force: true
  copy_file 'controllers/users_controller.rb.tt', 'app/controllers/users_controller.rb', force: true
  copy_file 'controllers/sessions_controller.rb.tt', 'app/controllers/sessions_controller.rb', force: true
  copy_file 'controllers/passwords_controller.rb.tt', 'app/controllers/passwords_controller.rb', force: true
  copy_file 'config/locales/clearance.en.yml.tt', 'config/locales/clearance.en.yml', force: true
  copy_file 'config/locales/dashboard.en.yml.tt', 'config/locales/dashboard.en.yml', force: true
  copy_file 'config/locales/shared.en.yml.tt', 'config/locales/shared.en.yml', force: true
  gsub_file 'config/routes.rb', 'clearance/', ''
  # copy_file 'spec/controllers/dashboard_controller_spec.rb.tt', 'spec/controllers/dashboard_controller_spec.rb', force: true
  copy_file 'images/blank-profile-picture.png', 'app/assets/images/blank-profile-picture.png'
  insert_into_file 'app/models/user.rb', after: 'include Clearance::User' do
    <<-RUBY

  def avatar_url
    'blank-profile-picture.png'
  end
RUBY
  end
  append_to_file 'db/seeds.rb' do
    <<-RUBY
if Rails.env.development?
  User.create_with(password: 'secret').find_or_create_by!(email: 'jdoe@example.com')
end
RUBY
  end
  insert_into_file 'app/controllers/application_controller.rb', after: 'include Clearance::Controller' do
    <<-RUBY

  before_action :require_login
RUBY
  end
  insert_into_file 'config/initializers/clearance.rb', after: 'Clearance.configure do |config|' do
    <<-RUBY
  config.redirect_url = '/dashboard'
RUBY

  end
  insert_into_file 'config/routes.rb', after: 'Rails.application.routes.draw do' do
    <<-RUBY
  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
RUBY
  end
  run 'bin/setup'
end
