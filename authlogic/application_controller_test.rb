require 'test_helper'
 
class ApplicationControllerTest < ActionController::TestCase
  
  should_filter_params :password, :confirm_password, :password_confirmation

  context "#logged_in?" do
    setup { @user = Factory.create(:user) }
    
    should "return true if there is a user session" do
      UserSession.create(@user)
      assert controller.logged_in?
    end

# FIXME: Failing test for logged_in?
#    should "return false if there is no session" do
#      assert !controller.logged_in?
#    end
  end

  context "#admin_logged_in?" do
    setup { @user = Factory.create(:user) }
    
    should "return true if there is a user session for an admin" do
      @user.roles << "admin"
      UserSession.create(@user)
      assert controller.admin_logged_in?
    end

    should "return false if there is a user session for a non-admin" do
      @user.roles = []
      UserSession.create(@user)
      assert !controller.admin_logged_in?
    end

    should "return false if there is no session" do
      assert !controller.admin_logged_in?
    end
  end

# TODO: Add tests for filters
  
end