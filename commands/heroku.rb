@commands.pre_bundle do
  gem "puma", "~> 2.11.2"
  gem "rails_12factor", "~> 0.0.3", group: :production
  append_to_file "Gemfile", <<-CODE

ruby '2.2.0'
CODE

  file "Procfile", <<-CODE
web: bundle exec puma -C config/puma.rb
CODE

  file "config/puma.rb", <<-CODE
workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
CODE
end
