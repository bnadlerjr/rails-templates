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

  context "filters" do
    setup { controller.stubs(:flash).returns(Hash.new) }

    context "with a current user" do
      setup do
        @user = Factory.create(:user)
        controller.stubs(:current_user).returns(@user)
      end

      context "no user required" do
        should "set the flash" do
          controller.expects(:redirect_to).with(new_user_session_url)
          controller.send(:require_no_user)
          assert_equal 'You must be logged out to access this page.', 
                       controller.instance_eval { flash[:notice] }
        end
      end

      context "user required" do
        should "not set the flash" do
          controller.send(:user_required)
          assert_nil controller.instance_eval { flash[:notice] }
        end
      end

      context "admin required" do
        context "without admin user" do
          should "set the flash" do
            controller.send(:admin_required)
            assert_equal 'Sorry, you don\'t have access to that.', 
                         controller.instance_eval { flash[:notice] }
          end
        end

        context "with admin user" do
          should "not set the flash" do
            @user.add_role('admin')
            controller.stubs(:current_user).returns(@user)
            assert_nil controller.instance_eval { flash[:notice] }
          end
        end
      end
    end

    context "without a current user" do
      setup { controller.stubs(:current_user).returns(false) }

      context "no user required" do
        should "not set the flash" do
          controller.send(:require_no_user)
          assert_nil controller.instance_eval { flash[:notice] }
        end
      end

      context "user required" do
        should "set the flash" do
          controller.expects(:redirect_to).with(new_user_session_url)
          controller.send(:user_required)
          assert_equal 'You must be logged in to access this page.', 
                       controller.instance_eval { flash[:notice] }
        end
      end

      context "admin required" do
        should "set the flash" do
          controller.expects(:redirect_to).with(new_user_session_url)
          controller.send(:admin_required)
          assert_equal 'You must be logged in to access this page.', 
                       controller.instance_eval { flash[:notice] }
        end
      end
    end
  end
end
