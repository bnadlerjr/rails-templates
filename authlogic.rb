ABOUT = <<-CODE
\n
|---------------------------------------------------------------------------------|
 Rails template for installing authlogic gem and scaffolding users / sessions.

 Based on the authlogic example app and password reset logic from 
    http://www.binarylogic.com/2008/11/16/tutorial-reset-passwords-with-authlogic/

 Generated tests assume Shoulda and factory_girl are present.

 IMPORTANT: This template overwrites application_controller.rb and factories.rb

Creates / Overwrites
 Create a user migration
 Overwrites user model and unit test
 
Merge
 factories.rb
 application_controller.rb
|---------------------------------------------------------------------------------|
CODE

TEMPLATE_ROOT ||= "http://github.com/thethirdswitch/rails-templates/raw/master/authlogic-templates"

if yes?(ABOUT + "\ncontinue?(y/n)")
  gem "authlogic"

  generate(:session, "user_session")
  generate(:model, "user --skip-migration")

  route "map.resources :users"
  load_template "#{TEMPLATE_ROOT}/create_users_migration.authlogic"
  
# file "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_create_users.rb", <<-CODE
# class CreateUsers < ActiveRecord::Migration
#   def self.up
#     create_table :users, :force => true do |t|
#       t.string :email,               :null => false
#       t.string :first_name,          :null => false
#       t.string :last_name,           :null => false
#       t.string :crypted_password,    :null => false
#       t.string :password_salt,       :null => false
#       t.string :persistence_token,   :null => false
#       t.string :single_access_token, :null => false
#       t.string :perishable_token,    :null => false
#       t.string :current_login_ip
#       t.string :last_login_ip
#
#       t.integer :login_count,        :null => false, :default => 0
#       t.integer :failed_login_count, :null => false, :default => 0
#
#       t.datetime :last_request_at
#       t.datetime :current_login_at
#       t.datetime :last_login_at
#     end
#
#     add_index :users, :email
#     add_index :users, :perishable_token
#   end
#
#   def self.down
#     remove_index :users, :perishable_token
#     remove_index :users, :email
#     drop_table :users
#   end
# end
# CODE

  file 'app/models/user.rb', <<-CODE
  class User < ActiveRecord::Base
    acts_as_authentic

    def full_name
      "\#{first_name} \#{last_name}"
    end

    def short_name
      "\#{first_name} \#{last_name.first}."
    end

    def deliver_password_reset_instructions!  
      reset_perishable_token!  
      Notifier.deliver_password_reset_instructions(self)  
    end
  end
  CODE

  file 'test/unit/user_test.rb', <<-CODE
  require 'test_helper'

  class UserTest < ActiveSupport::TestCase
    context 'a user instance' do
      setup { @user = Factory.create(:user) }

      should 'return a full name' do
        assert_equal('John Doe', @user.full_name)
      end

      should 'return a short name' do
        assert_equal('John D.', @user.short_name)
      end
    end
  end
  CODE
  
  file 'test/factories.rb', <<-CODE
  Factory.define :user do |f|
    f.email 'john.doe@example.com'
    f.password 'secret'
    f.password_confirmation 'secret'
    f.first_name 'John'
    f.last_name 'Doe'
  end
  CODE
  
  file 'app/controllers/users_controller.rb', <<-CODE
  class UsersController < ApplicationController
    before_filter :find_user, :only => [:show, :edit, :update, :destroy]

    # GET /users
    # GET /users.xml
    def index
      @users = User.all

      respond_to do |wants|
        wants.html # index.html.erb
        wants.xml  { render :xml => @users }
      end
    end

    # GET /users/1
    # GET /users/1.xml
    def show
      respond_to do |wants|
        wants.html # show.html.erb
        wants.xml  { render :xml => @user }
      end
    end

    # GET /users/new
    # GET /users/new.xml
    def new
      @user = User.new

      respond_to do |wants|
        wants.html # new.html.erb
        wants.xml  { render :xml => @user }
      end
    end

    # GET /users/1/edit
    def edit
    end

    # POST /users
    # POST /users.xml
    def create
      @user = User.new(params[:user])

      respond_to do |wants|
        if @user.save
          flash[:notice] = 'User was successfully created.'
          wants.html { redirect_to(@user) }
          wants.xml  { render :xml => @user, :status => :created, :location => @user }
        else
          wants.html { render :action => "new" }
          wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    end

    # PUT /users/1
    # PUT /users/1.xml
    def update
      respond_to do |wants|
        if @user.update_attributes(params[:user])
          flash[:notice] = 'User was successfully updated.'
          wants.html { redirect_to(@user) }
          wants.xml  { head :ok }
        else
          wants.html { render :action => "edit" }
          wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    end

    # DELETE /users/1
    # DELETE /users/1.xml
    def destroy
      @user.destroy

      respond_to do |wants|
        wants.html { redirect_to(users_url) }
        wants.xml  { head :ok }
      end
    end

    private

    def find_user
      @user = User.find(params[:id])
    end
  end
  CODE

  generate(:controller, "user_sessions")
  route "map.resource :user_session, :only => [:new, :create, :destroy]"
  route "map.root :controller => 'user_sessions', :action => 'new'"
  
  file 'app/controllers/user_sessions_controller.rb', <<-CODE
  class UserSessionsController < ApplicationController
    before_filter :require_no_user, :only => [:new, :create]
    before_filter :require_user, :only => :destroy

    def new
      @user_session = UserSession.new
    end

    def create
      @user_session = UserSession.new(params[:user_session])
      if @user_session.save
        flash[:success] = "Login successful!"
        redirect_to home_url
      else
        render :action => :new
      end
    end

    def destroy
      current_user_session.destroy
      flash[:notice] = "Logout successful!"
      redirect_to new_user_session_url
    end
  end
  CODE

  file 'app/views/user_sessions/new.html.erb', <<-CODE
  <p>Placeholder for new.html.erb</p>
  CODE
  
  file 'test/functional/user_sessions_controller_test.rb', <<-CODE
  require 'test_helper'

  class UserSessionsControllerTest < ActionController::TestCase
    setup do
      @user = Factory.create(:user)
      :activate_authlogic
    end

    context 'GET new' do
      setup { get :new }

      should_respond_with :success
      should_render_template :new    
    end

    context 'POST create' do
      context 'good credentials' do
        setup { post :create, :user_session => { :email => "john.doe@example.com", :password => "secret" } }

        should_assign_to :user_session
        should_respond_with :redirect
        should_redirect_to('root url') { root_url }
        should_set_the_flash_to 'Login successful!'

        should 'save user to session' do
          assert(UserSession.find)
        end      
      end

      context 'bad email' do
        setup { post :create, :user_session => { :email => "bad@example.com", :password => "secret" } }

        should_respond_with :success
        should_render_template :new
        should_set_the_flash_to 'Invalid email or password.'
      end

      context 'bad password' do
        setup { post :create, :user_session => { :email => "john.doe@example.com", :password => "bad" } }

        should_respond_with :success
        should_render_template :new
        should_set_the_flash_to 'Invalid email or password.'
      end
    end

    context 'DELETE destroy' do
      setup do
        UserSession.create(@user)
        delete :destroy
      end

      should_respond_with :redirect
      should_redirect_to('new user session') { new_user_session_path }
      should_set_the_flash_to 'Logout successful!'

      should 'destroy the session' do
        assert_nil(UserSession.find)
      end
    end
  end
  CODE
  
  file 'app/controllers/application_controller.rb', <<-CODE
  # Filters added to this controller apply to all controllers in the application.
  # Likewise, all the methods added will be available for all controllers.

  class ApplicationController < ActionController::Base
    helper :all # include all helpers, all the time
    protect_from_forgery # See ActionController::RequestForgeryProtection for details

    # Scrub sensitive parameters from your log
    filter_parameter_logging :password, :password_confirmation

    helper_method :current_user_session, :current_user


    private

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
  end
  CODE

  generate(:controller, "password_resets")

  file 'app/controllers/password_resets_controller', <<-CODE
  class PasswordResetsController < ApplicationController  
    before_filter :load_user_using_perishable_token, :only => [:edit, :update]

    def new  
      render  
    end  

    def create  
      @user = User.find_by_email(params[:email])  
      if @user  
        @user.deliver_password_reset_instructions!  
        flash[:success] = "Instructions to reset your password have been emailed to you. Please check your email."
        redirect_to root_url  
      else  
        flash[:notice] = "No user was found with that email address"  
        render :action => :new  
      end  
    end  

    def edit  
      render  
    end  

    def update  
      @user.password = params[:user][:password]  
      @user.password_confirmation = params[:user][: password_confirmation]  
      if @user.save  
        flash[:success] = "Password successfully updated."  
        redirect_to account_url  
      else  
        render :action => :edit  
      end  
    end  

    private  

    def load_user_using_perishable_token  
      @user = User.find_using_perishable_token(params[:id])  
      unless @user  
        flash[:error] = "We're sorry, but we could not locate your account. " +  
        "If you are having issues try copying and pasting the URL " +  
        "from your email into your browser or restarting the " +  
        "reset password process."  
        redirect_to root_url  
      end  
    end
  end
  CODE

  file 'app/models/notifier.rb', <<-CODE
  class Notifier < ActionMailer::Base  
    default_url_options[:host] = "authlogic_example.binarylogic.com"  

    def password_reset_instructions(user)  
      subject       "Password Reset Instructions"  
      from          "Application Notifier "  
      recipients    user.email  
      sent_on       Time.now  
      body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
    end  
  end
  CODE

  file 'app/views/notifier/password_reset_instructions.erb', <<-CODE
  A request to reset your password has been made.  
  If you did not make this request, simply ignore this email.  
  If you did make this request just click the link below:  

  If the above URL does not work try copying and pasting it into your browser.  
  If you continue to have problem please feel free to contact us.
  CODE
end