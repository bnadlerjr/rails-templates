require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  context 'on GET to :new' do
    setup do
      controller.stubs(:no_user_required).returns(true)
      the_user_session = UserSession.new
      get :new
    end

    should_respond_with :success
    should_render_template :new
    should_not_set_the_flash
  end

  context 'on POST to :create' do
    setup do
      controller.stubs(:no_user_required).returns(true)
      @the_user_session = UserSession.new
      UserSession.stubs(:new).returns(@the_user_session)
    end
    
    context 'with good credentials' do
      setup do
        @the_user_session.stubs(:save).returns(true)
        post :create, :user_session => {}
      end

      should_respond_with :redirect
      should_redirect_to('home page') { root_path }
      should_set_the_flash_to 'Login successful!'
    end

    context 'with bad email' do
      setup do
        @the_user_session.stubs(:save).returns(false)
        post :create, :user_session => {}
      end

      should_respond_with :success
      should_render_template :new
      should_set_the_flash_to 'Incorrect email or password. Please try again.'
    end

    context 'with bad password' do
      setup do
        @the_user_session.stubs(:save).returns(false)
        post :create, :user_session => {}
      end

      should_respond_with :success
      should_render_template :new
      should_set_the_flash_to 'Incorrect email or password. Please try again.'
    end
  end

  context 'on DELETE :destroy' do
    setup do
      @user = Factory.create(:user)
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
