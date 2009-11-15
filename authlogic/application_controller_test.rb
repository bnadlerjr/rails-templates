require 'test_helper'
 
class ApplicationControllerTest < ActionController::TestCase
  
  should_filter_params :password, :confirm_password, :password_confirmation

  context "logged_in?" do
    should "return true if there is a user session" do
      @user = Factory.create(:user)
      UserSession.create(@user)
      assert controller.logged_in?
    end

    should "return false if there is no session" do
      assert !controller.logged_in?
    end
  end

  context "admin_logged_in?" do
    should "return true if there is a user session for an admin" do
      @user = Factory.create(:user)
      @user.roles << "admin"
      UserSession.create(@user)
      assert controller.admin_logged_in?
    end

    should "return false if there is a user session for a non-admin" do
      @user = Factory.create(:user)
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