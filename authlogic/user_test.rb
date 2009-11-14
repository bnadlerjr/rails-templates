require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context 'a user instance' do
    setup { @user = Factory.create(:user) }
    subject { @user }
    
    should_allow_mass_assignment_of :password, :password_confirmation, :first_name, :last_name, :email
    
    should_not_allow_mass_assignment_of :crypted_password, :password_salt, :persistence_token, 
                                        :login_count, :last_request_at, :last_login_at, :current_login_at,
                                        :last_login_ip, :current_login_ip, :roles, :created_at, 
                                        :updated_at, :id
    
    should 'return a full name' do
      assert_equal('John Doe', @user.full_name)
    end

    should 'return a short name' do
      assert_equal('John D.', @user.short_name)
    end
    
    context "#deliver password reset instructions" do
      setup { Notifier.stubs(:deliver_password_reset_instructions) }
      
      should "reset the perishable token" do
        @user.expects(:reset_perishable_token!)
        @user.deliver_password_reset_instructions!
      end
      
      should "send the reset email" do
        Notifier.expects(:deliver_password_reset_instructions).with(@user)
        @user.deliver_password_reset_instructions!
      end
    end
    
    context "roles" do
      context "serialization" do
        should "default to an empty array" do
          assert_equal([], @user.roles)
        end
      
        should "allow saving and retrieving roles array" do
          roles = ['developer', 'tester', 'project manager']
          @user.roles = roles
          @user.save
          assert_equal(roles, User.find(@user.id).roles)
        end
      
        should "not allow non-array data" do
          assert_raise ActiveRecord::SerializationTypeMismatch do
            @user.roles = "invalid role list"
            @user.save
          end
        end
      end
      
      context "admin? method" do
        should "return true if user has admin role" do
          @user.add_role("admin")
          assert @user.admin?
        end
        
        should "return false if user does not have admin role" do
          assert !@user.admin?
        end
      end
      
      context "has_role? method" do
        should "return true if user has role" do
          @user.add_role('approver')
          assert @user.has_role?('approver')
        end
        
        should "return false if user does not have role" do
          assert !@user.has_role?('approver')
        end
      end
      
      context "management" do
        should "add the specified role" do
          assert !@user.has_role?('submitter')
          @user.add_role('submitter')
          assert @user.roles.include?('submitter')
        end
        
        should "remove the specified role" do
          roles = ['submitter', 'approver', 'doer']
          @user.roles = roles
          assert_equal(roles, @user.roles)
          @user.remove_role('approver')
          assert_equal(roles - ['approver'], @user.roles)
        end
        
        should "have no roles after clearing" do
          @user.roles = ['submitter', 'approver', 'doer']
          @user.clear_roles
          assert [], @user.roles
        end
      end
    end
  end
end