require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  setup do
    @user = Factory.create(:user)
  end

  context 'on GET to :new' do
    setup do
      controller.stubs(:require_no_user).returns(true)
      @the_user_session = UserSession.new
      get :new
    end

    should_respond_with :success
    should_render_template :new
    should_not_set_the_flash
  end

  context 'on POST to :create' do
    setup do
      controller.stubs(:require_no_user).returns(true)
      @the_user_session = UserSession.new
      UserSession.stubs(:new).returns(@the_user_session)
    end
    
    context 'with good credentials' do
      setup do
        @the_user_session.stubs(:save).returns(true)
        post :create, :user_session => { :email => "john.doe@example.com", :password => "secret" }
      end

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