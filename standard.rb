# require_relative "lib/commands"

# @commands = Commands.new

# %w(rspec cucumber rspec_cucumber_ci letter_opener bullet heroku devise).each do |cmd|
  # apply File.join(File.dirname(__FILE__), "commands", "#{cmd}.rb")
# end

# @commands.execute(:pre_bundle)
# after_bundle { @commands.execute(:post_bundle) }

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
template "database.yml.tt", 'config/database.yml', force: true
copy_file "puma.rb.tt", 'config/puma.rb', force: true
copy_file 'generators.rb.tt', "config/initializers/generators.rb"
copy_file 'rotate_log.rb.tt', "config/initializers/rotate_log.rb"

gsub_file "config/initializers/filter_parameter_logging.rb", /\[:password\]/ do
  "%w[password secret session cookie csrf]"
end

mailer_regex = /config\.action_mailer\.raise_delivery_errors = false\n/
comment_lines "config/environments/development.rb", mailer_regex
insert_into_file "config/environments/development.rb", after: mailer_regex do
  <<-RUBY

  # Ensure mailer works in development.
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: "localhost:3000" }
  config.action_mailer.asset_host = "http://localhost:3000"
  RUBY
end

# apply "config/environments/development.rb"
# apply "config/environments/production.rb"
# apply "config/environments/test.rb"
# template "config/environments/staging.rb.tt"

# route 'root "home#index"'
# route %Q(mount Sidekiq::Web => "/sidekiq" # monitoring console\n)

  # apply "doc/template.rb"
  # apply "lib/template.rb"
  # apply "test/template.rb"
