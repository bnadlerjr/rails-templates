@commands.pre_bundle do
  puts " Configuring Factory Girl"
  puts "-------------------------------------------------------------------------"
  gem  'rails3-generators', :group => :development
  gem  'factory_girl_rails'

  gsub_file 'config/application.rb', /# Configure the default encoding used in templates for Ruby 1.9./ do
  <<-RUBY
  config.generators do |g|
        g.fixture_replacement :factory_girl
      end

      # Configure the default encoding used in templates for Ruby 1.9.
  RUBY
  end
end
