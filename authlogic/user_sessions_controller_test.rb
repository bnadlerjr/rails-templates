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