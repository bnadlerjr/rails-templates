# TODO:
# * Scaffold templates that incorporate the theme
# * Fix Bullet
# * Setup CircleCI
# * Flesh out README
# * Ability to upload an avatar on profile page
# * Add ActiveHash
# * Add Royce-Rolls
# * Add pagy
# * DataTables jQuery plugin
# * Option for public signup
# * Add annotate models gem
# * Look into using SCSS files individually so that colors can be customized
# * Does logging out require a modal?
# * Specs for all clearance controllers
# * Do I want to include cucumber?
# * Remove search bar from topbar

# DONE IN EXAMPLE APP

source_paths.unshift(File.join(File.dirname(__FILE__), 'lib', 'templates'))
template 'Gemfile.tt', force: true
template 'README.md.tt', force: true
remove_file 'README.rdoc'
template 'example.env.tt'
copy_file 'gitignore', '.gitignore', force: true
copy_file 'rubocop.yml', '.rubocop.yml'
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
copy_file 'application.js.tt', 'app/javascript/packs/application.js', force: true
remove_file 'app/assets/stylesheets/application.css'
remove_dir 'test'

gsub_file 'config/initializers/filter_parameter_logging.rb', /\[:password\]/ do
  '%w[password secret session cookie csrf]'
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

  # config.after_initialize do
  #   Bullet.enable = true
  #   Bullet.console = true
  #   Bullet.rails_logger = true
  # end
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

run('bin/yarn add @fortawesome/fontawesome-free')
run('bin/yarn add startbootstrap-sb-admin-2')
run('bin/yarn add popper.js')

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
  gsub_file 'spec/spec_helper.rb', '=begin', ''
  gsub_file 'spec/spec_helper.rb', '=end', ''
  gsub_file 'spec/rails_helper.rb', /  # Remove this line.*/, ''
  gsub_file 'spec/rails_helper.rb', /config\.fixture_path.*/, 'config.include FactoryBot::Syntax::Methods'
  gsub_file 'spec/rails_helper.rb', /\# Add additional requires.*/, "require 'clearance/rspec'"
  generate 'clearance:install'
  copy_file 'application.html.erb.tt', 'app/views/layouts/application.html.erb', force: true
  copy_file 'site.html.erb.tt', 'app/views/layouts/site.html.erb', force: true
  copy_file 'views/users/new.html.erb.tt', 'app/views/users/new.html.erb', force: true
  copy_file 'views/users/edit.html.erb.tt', 'app/views/users/edit.html.erb', force: true
  copy_file 'views/sessions/new.html.erb.tt', 'app/views/sessions/new.html.erb', force: true
  copy_file 'views/dashboard/index.html.erb.tt', 'app/views/dashboard/index.html.erb', force: true
  copy_file 'views/passwords/new.html.erb.tt', 'app/views/passwords/new.html.erb', force: true
  copy_file 'views/passwords/edit.html.erb.tt', 'app/views/passwords/edit.html.erb', force: true
  copy_file 'views/passwords/create.html.erb.tt', 'app/views/passwords/create.html.erb', force: true
  copy_file 'views/shared/_search.html.erb.tt', 'app/views/shared/_search.html.erb', force: true
  copy_file 'views/shared/_topbar.html.erb.tt', 'app/views/shared/_topbar.html.erb', force: true
  copy_file 'views/shared/_sidebar.html.erb.tt', 'app/views/shared/_sidebar.html.erb', force: true
  copy_file 'views/shared/_content.html.erb.tt', 'app/views/shared/_content.html.erb', force: true
  copy_file 'views/shared/_user_menu.html.erb.tt', 'app/views/shared/_user_menu.html.erb', force: true
  copy_file 'views/shared/_footer.html.erb.tt', 'app/views/shared/_footer.html.erb', force: true
  copy_file 'controllers/dashboard_controller.rb.tt', 'app/controllers/dashboard_controller.rb', force: true
  copy_file 'controllers/users_controller.rb.tt', 'app/controllers/users_controller.rb', force: true
  copy_file 'controllers/sessions_controller.rb.tt', 'app/controllers/sessions_controller.rb', force: true
  copy_file 'controllers/passwords_controller.rb.tt', 'app/controllers/passwords_controller.rb', force: true
  copy_file 'config/locales/clearance.en.yml.tt', 'config/locales/clearance.en.yml', force: true
  copy_file 'config/locales/dashboard.en.yml.tt', 'config/locales/dashboard.en.yml', force: true
  copy_file 'config/locales/profile.en.yml.tt', 'config/locales/profile.en.yml', force: true
  copy_file 'config/locales/shared.en.yml.tt', 'config/locales/shared.en.yml', force: true
  copy_file 'images/blank-profile-picture.png', 'app/assets/images/blank-profile-picture.png'
  insert_into_file 'app/helpers/application_helper.rb', after: 'module ApplicationHelper' do
    <<-RUBY
  def display_flash(type, msg)
    css_class_map = {
      notice: 'info',
      alert: 'danger',
      success: 'success',
      error: 'danger'
    }
    css_class = css_class_map.fetch(type.to_sym)
    tag.div(msg, class: "alert alert-#{css_class}")
  end

  def menu_link_to(path, &block)
    html_class = request.path.starts_with?(path) ? 'nav-item active' : 'nav-item'
    content_tag 'li', class: html_class do
      link_to(path, class: 'nav-link', &block)
    end
  end
    RUBY
  end
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

  get '/sign_in' => 'sessions#new', as: 'sign_in'
  get '/sign_up' => 'users#new', as: 'sign_up'
  get 'dashboard', to: 'dashboard#index'
  get 'profile', to: 'users#edit'

  delete '/sign_out' => 'sessions#destroy', as: 'sign_out'

  resources :passwords, controller: 'passwords', only: [:create, :new]
  resource :session, controller: 'sessions', only: [:create]

  resources :users, controller: 'users', only: [:create, :edit, :update] do
    resource :password, controller: 'passwords', only: [:edit, :update]
  end
    RUBY
  end
  run 'bundle binstubs rspec-core'
  run 'bundle binstubs rubocop'

  insert_into_file 'config/webpack/environment.js', after: "const { environment } = require('@rails/webpacker')" do
    <<-JAVASCRIPT

const webpack = require('webpack')
environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/dist/jquery',
        jQuery: 'jquery/dist/jquery',
        Popper: ['popper.js', 'default']
    })
)

    JAVASCRIPT
  end

  gsub_file 'node_modules/startbootstrap-sb-admin-2/js/sb-admin-2.js', '(function($) {', "$(document).on('turbolinks:load', function() {"
  gsub_file 'node_modules/startbootstrap-sb-admin-2/js/sb-admin-2.js', '})(jQuery); // End of use strict', '})'
end
