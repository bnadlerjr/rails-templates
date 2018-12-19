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
  run 'bundle binstubs rspec-core'
  generate 'clearance:install'
  generate 'clearance:routes'
  generate 'clearance:views'
  run 'bundle exec rake db:migrate'
end
