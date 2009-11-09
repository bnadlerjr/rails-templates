ABOUT = <<-CODE
\n
|---------------------------------------------------------------------------------|
 Rails template for setting up testing frameworks.

 IMPORTANT: This template overwrites test_helper.rb and is meant to be run from a
            fresh app.
|---------------------------------------------------------------------------------|
CODE

if yes?(ABOUT + "\ncontinue?(y/n)")

  run "rm -R test/integration"

  gem "thoughtbot-factory_girl", :lib => "factory_girl", :environment => :test
  gem "thoughtbot-shoulda", :lib => "shoulda", :environment => :test
  gem "autotest-rails", :lib => "autotest/rails", :environment => :test
  gem "cucumber", :environment => :test
  gem "webrat", :environment => :test

  generate :cucumber

  file 'test/factories.rb', <<-CODE
  # Example:
  # Factory.define :user do |f|
  #   f.email 'john.doe@example.com'
  #   f.password 'secret'
  #   f.password_confirmation 'secret'
  #   f.first_name 'John'
  #   f.last_name 'Doe'
  # end
  CODE

  file 'test/test_helper.rb', <<-CODE
  ENV["RAILS_ENV"] = "test"
  ENV["AUTOFEATURE"] = "true"

  require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
  require 'test_help'
  require File.expand_path(File.dirname(__FILE__) + "/factories")

  class ActiveSupport::TestCase
    # Transactional fixtures accelerate your tests by wrapping each test method
    # in a transaction that's rolled back on completion.  This ensures that the
    # test database remains unchanged so your fixtures don't have to be reloaded
    # between every test method.  Fewer database queries means faster tests.
    #
    # Read Mike Clark's excellent walkthrough at
    #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
    #
    # Every Active Record database supports transactions except MyISAM tables
    # in MySQL.  Turn off transactional fixtures in this case; however, if you
    # don't care one way or the other, switching from MyISAM to InnoDB tables
    # is recommended.
    #
    # The only drawback to using transactional fixtures is when you actually 
    # need to test transactions.  Since your test is bracketed by a transaction,
    # any transactions started in your code will be automatically rolled back.
    self.use_transactional_fixtures = true

    # Instantiated fixtures are slow, but give you @david where otherwise you
    # would need people(:david).  If you don't want to migrate your existing
    # test cases which use the @david style and don't mind the speed hit (each
    # instantiated fixtures translates to a database query per test method),
    # then set this back to true.
    self.use_instantiated_fixtures  = false

    # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
    #
    # Note: You'll currently still have to declare fixtures explicitly in integration tests
    # -- they do not yet inherit this setting
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
  CODE
end