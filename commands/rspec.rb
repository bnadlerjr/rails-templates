@commands.pre_bundle do
  gem_group :development, :test do
    gem "rspec-rails", "~> 3.2.1"
    gem "spring-commands-rspec", "~> 1.0.4"
    gem "factory_girl_rails", "~> 4.5.0"
  end
end

@commands.post_bundle do
  generate "rspec:install"
end
