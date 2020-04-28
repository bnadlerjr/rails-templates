source_paths.unshift(File.join(File.dirname(__FILE__), 'lib', 'templates'))
template 'Gemfile.tt', force: true
template 'README.md.tt', force: true
remove_file 'README.rdoc'
template 'example.env.tt'
copy_file 'gitignore', '.gitignore', force: true
copy_file 'rubocop.yml', '.rubocop.yml'
copy_file 'Procfile'
copy_file 'circleci.yml', '.circleci/config.yml'
copy_file 'bin/setup', force: true
chmod 'bin/setup', '+x'
copy_file 'bin/update', force: true
chmod 'bin/update', '+x'
copy_file 'bin/ci'
chmod 'bin/ci', '+x'
copy_file 'bin/pre-commit'
chmod 'bin/pre-commit', '+x'
template 'database.yml.tt', 'config/database.yml', force: true
copy_file 'puma.rb.tt', 'config/puma.rb', force: true
copy_file 'generators.rb.tt', 'config/initializers/generators.rb'
copy_file 'rotate_log.rb.tt', 'config/initializers/rotate_log.rb'
copy_file 'application.scss.tt', 'app/assets/stylesheets/application.scss'
copy_file 'stylesheets/modules/editable-avatar.scss', 'app/assets/stylesheets/modules/editable-avatar.scss'
copy_file 'application.js.tt', 'app/javascript/packs/application.js', force: true
copy_file 'data-tables.js.tt', 'app/javascript/data-tables.js'
copy_file 'sb-admin-2.js.tt', 'app/javascript/sb-admin-2.js'
remove_file 'app/assets/stylesheets/application.css'
remove_dir 'test'

gsub_file 'config/initializers/filter_parameter_logging.rb', /\[:password\]/ do
  '%w[password secret session cookie csrf]'
end

mailer_regex = /config\.action_mailer\.raise_delivery_errors = false\n/
comment_lines 'config/environments/development.rb', mailer_regex
uncomment_lines 'config/environments/production.rb', /config\.force_ssl = true/
gsub_file 'config/environments/production.rb', ':local', ':amazon'

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

  # Enable Clearance backdoor for request specs
  config.middleware.use Clearance::BackDoor
  RUBY
end

yarn_deps = [
  '@fortawesome/fontawesome-free',
  'popper.js',
  'bootstrap@4.4.1',
  'datatables.net',
  'datatables.net-bs4',
  'startbootstrap-sb-admin-2',
  'cropperjs',
  'eslint',
  'eslint-config-standard',
  'eslint-plugin-import',
  'eslint-plugin-node',
  'eslint-plugin-promise',
  'eslint-plugin-standard'
]
run("bin/yarn add #{yarn_deps.join(' ')}")

after_bundle do
  run 'spring stop'
  generate 'rspec:install'
  prepend_to_file 'spec/spec_helper.rb' do
    <<-RUBY
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/lib/templates/'
  add_filter '/spec/'
end
puts 'REQUIRED SIMPLECOV'

RUBY
  end

  generate 'annotate:install'
  copy_file 'tasks/auto_annotate_models.rake', 'lib/tasks/auto_annotate_models.rake', force: true

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

  gsub_file 'spec/spec_helper.rb', '=begin', ''
  gsub_file 'spec/spec_helper.rb', '=end', ''
  gsub_file 'spec/rails_helper.rb', /  # Remove this line.*/, ''
  gsub_file 'spec/rails_helper.rb', /config\.fixture_path.*/, 'config.include FactoryBot::Syntax::Methods'
  gsub_file 'spec/rails_helper.rb', /\# Add additional requires.*/, "require 'clearance/rspec'"
  generate 'clearance:install'
  generate 'royce:install'
  generate 'flipper:active_record'
  copy_file 'flipper.rb.tt', 'config/initializers/flipper.rb'
  copy_file 'application.html.erb.tt', 'app/views/layouts/application.html.erb', force: true
  copy_file 'site.html.erb.tt', 'app/views/layouts/site.html.erb', force: true
  copy_file 'models/data_table.rb.tt', 'app/models/data_table.rb'
  copy_file 'models/concerns/searchable.rb.tt', 'app/models/concerns/searchable.rb'
  copy_file 'views/users/new.html.erb.tt', 'app/views/users/new.html.erb', force: true
  copy_file 'views/users/edit.html.erb.tt', 'app/views/users/edit.html.erb', force: true
  copy_file 'views/users/show.json.jb', 'app/views/users/show.json.jb', force: true
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
  copy_file 'config/locales/data_tables.en.yml.tt', 'config/locales/data_tables.en.yml', force: true
  copy_file 'config/locales/flash.en.yml.tt', 'config/locales/flash.en.yml', force: true
  copy_file 'images/blank-profile-picture.png', 'app/assets/images/blank-profile-picture.png'
  copy_file 'spec/factories/users.rb.tt', 'spec/factories/users.rb'
  copy_file 'spec/requests/users_spec.rb', 'spec/requests/users_spec.rb'
  copy_file 'spec/support/expectations.rb', 'spec/support/expectations.rb'
  copy_file 'spec/support/shoulda.rb', 'spec/support/shoulda.rb'
  copy_file 'spec/support/concerns/searchable.rb', 'spec/support/concerns/searchable.rb'
  copy_file 'rails/scaffold_controller/controller.rb.tt', 'lib/templates/rails/scaffold_controller/controller.rb.tt'
  copy_file 'rails/jb/index.json.jb', 'lib/templates/rails/jb/index.json.jb'
  copy_file 'erb/scaffold/_form.html.erb.tt', 'lib/templates/erb/scaffold/_form.html.erb.tt'
  copy_file 'erb/scaffold/edit.html.erb.tt', 'lib/templates/erb/scaffold/edit.html.erb.tt'
  copy_file 'erb/scaffold/index.html.erb.tt', 'lib/templates/erb/scaffold/index.html.erb.tt'
  copy_file 'erb/scaffold/new.html.erb.tt', 'lib/templates/erb/scaffold/new.html.erb.tt'
  copy_file 'erb/scaffold/show.html.erb.tt', 'lib/templates/erb/scaffold/show.html.erb.tt'
  copy_file 'rspec/scaffold/request_spec.rb', 'lib/templates/rspec/scaffold/request_spec.rb'
  copy_file 'rspec/model/model_spec.rb', 'lib/templates/rspec/model/model_spec.rb'
  copy_file 'storage.yml', 'config/storage.yml', force: true
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
    tag.div msg, class: "alert alert-" + css_class
  end

  def menu_link_to(path, &block)
    html_class = request.path.starts_with?(path) ? 'nav-item active' : 'nav-item'
    content_tag 'li', class: html_class do
      link_to(path, class: 'nav-link', &block)
    end
  end

  def data_table(url:, &block)
    options = {
      class: 'table',
      role: 'datatable',
      width: '100%',
      cellspacing: 0,
      data: { url: url }
    }
    tag.div class: 'table-responsive' do
      tag.table options do
        yield block
      end
    end
  end

  def avatar_image_tag(user, size:, css: 'img-fluid')
    options = { class: css + " avatar", alt: 'Avatar image' }
    if user.avatar.attached?
      source = user.avatar.variant(resize_to_limit: [size, size]).processed
    else
      source = 'blank-profile-picture.png'
      options.merge!(width: size, height: size)
    end
    image_tag source, options
  end
    RUBY
  end

  royce_migration_file = Dir['db/migrate/*_create_royce.rb'].first
  gsub_file royce_migration_file,
            'class CreateRoyce < ActiveRecord::Migration',
            'class CreateRoyce < ActiveRecord::Migration[6.0]'

  gsub_file royce_migration_file, 'add_index :royce_connector, :role_id', ''

  insert_into_file 'app/models/user.rb', after: 'include Clearance::User' do
    <<-RUBY

  include ActiveStorageSupport::SupportForBase64

  royce_roles %w[user admin]

  has_one_base64_attached :avatar
    RUBY
  end

  append_to_file 'db/seeds.rb' do
    <<-RUBY
if Rails.env.development?
  User \
    .create_with(password: 'secret', roles: [Royce::Role.find_by(name: 'admin')]) \
    .find_or_create_by!(email: 'jdoe@example.com')
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

  config.routes = false
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

  constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
    mount Flipper::UI.app(Flipper) => '/flipper'
  end
    RUBY
  end

  insert_into_file 'config/webpack/environment.js', after: "const { environment } = require('@rails/webpacker')" do
    <<-JAVASCRIPT

const webpack = require('webpack')
environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/dist/jquery',
        jQuery: 'jquery/dist/jquery',
        Popper: ['popper.js', 'default'],
        Cropper: 'cropperjs/dist/cropper'
    })
)

    JAVASCRIPT
  end

  gsub_file 'node_modules/startbootstrap-sb-admin-2/js/sb-admin-2.js', '(function($) {', "$(document).on('turbolinks:load', function() {"
  gsub_file 'node_modules/startbootstrap-sb-admin-2/js/sb-admin-2.js', '})(jQuery); // End of use strict', '})'
  gsub_file 'app/javascript/channels/consumer.js', 'import { createConsumer } from "@rails/actioncable"', "import { createConsumer } from '@rails/actioncable'"
  copy_file 'eslintrc.yml', '.eslintrc.yml'
  copy_file 'javascript/avatar.js', 'app/javascript/avatar.js'
  copy_file 'javascript/facade.js', 'app/javascript/facade.js'
  copy_file 'javascript/mini-app.js', 'app/javascript/mini-app.js'
  copy_file 'javascript/modules/avatar/image.js', 'app/javascript/modules/avatar/image.js'
  copy_file 'javascript/modules/avatar/modal.js', 'app/javascript/modules/avatar/modal.js'
  copy_file 'javascript/modules/user/form.js', 'app/javascript/modules/user/form.js'

  run 'bundle binstubs rspec-core'
  run 'bundle binstubs rubocop'

  puts "\n=== project generation complete\n"
  puts "cd into project folder then run"
  puts "    ./bin/rails active_storage:install && ./bin/setup"
end
