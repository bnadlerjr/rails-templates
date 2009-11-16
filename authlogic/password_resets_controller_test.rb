require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase
  context "on GET to :new" do
    setup do
      controller.stubs(:require_no_user).returns(true)
      get :new
    end
    
    should_respond_with :success
    should_render_template :new
    should_not_set_the_flash
  end
  
  context "on POST to :create" do
    setup do
      Notifier.stubs(:deliver_password_reset_instructions)
      controller.stubs(:require_no_user).returns(true)
    end

    context "with user not found" do
      setup do
        User.stubs(:find_by_email).returns(false)
        post :create, :email => "john.doe@example.com"
      end

      should_respond_with :success
      should_set_the_flash_to "No user was found with that email address."
      should_render_template :new
    end
    
    context "with user found" do
      setup do
        User.stubs(:find_by_email).returns(Factory.create(:user))
        post :create, :email => "john.doe@example.com"
      end
  
      should_respond_with :redirect
      should_set_the_flash_to "Instructions to reset your password have been emailed to you. " +
                              "Please check your email."
      should_redirect_to("the home page") { root_url }
    end
  end
  
  context "on GET to :edit" do
    setup do
      controller.stubs(:require_no_user).returns(true)
      User.stubs(:find_using_perishable_token).returns(Factory.create(:user))
      get :edit, :id => "the token"
    end
    
    should_respond_with :success
    should_render_template :edit
    should_not_set_the_flash
    
    context "with invalid token" do
      setup do
        User.stubs(:find_using_perishable_token).returns(nil)
        get :edit, :id => "the token"
      end
      
      should_set_the_flash_to /could not locate your account/
      should_respond_with :redirect
      should_redirect_to("the home page") { root_url }
    end
  end
  
  context "on PUT to :update" do
    setup do
      controller.stubs(:require_no_user).returns(true)
      User.stubs(:find_using_perishable_token).returns(Factory.create(:user))
    end
  
    context "with successful save" do
      setup do
        User.any_instance.stubs(:save).returns(true)
        put :update, :id => "the token", :user => {:password => "the new password", :password_confirmation => "the new password"}
      end

      should_respond_with :redirect
      should_set_the_flash_to "Password successfully updated."
      should_redirect_to("the user's page") { root_url }
    end
  
    context "with failed save" do
      setup do
        User.any_instance.stubs(:save).returns(false)
        put :update, :id => "the token", :user => {:password => "the new password", :password_confirmation => "the new password"}
      end

      should_respond_with :success
      should_not_set_the_flash
      should_render_template :edit
    end

    context "with invalid token" do
      setup do
        User.stubs(:find_using_perishable_token).returns(nil)
        get :edit, :id => "the token"
      end
      
      should_set_the_flash_to /could not locate your account/
      should_respond_with :redirect
      should_redirect_to("the home page") { root_url }
    end
  end
end