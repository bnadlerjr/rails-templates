@commands.pre_bundle do
  gem_group :development, :test do
    gem "cucumber-rails", "~> 1.4.2", require: false
    gem "database_cleaner", "~> 1.4.1"
    gem "spring-commands-cucumber", "~> 1.0.1"
  end
end

@commands.post_bundle do
  generate "cucumber:install"
end
