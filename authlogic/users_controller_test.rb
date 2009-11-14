require 'test_helper'
 
class UsersControllerTest < ActionController::TestCase
  context "with a regular user" do
    setup do
      @user = Factory.create(:user)
      controller.stubs(:user_required).returns(true)
    end
 
    context "on GET to :show" do
      setup do
        get :show, :id => @user.id
      end

      should_assign_to(:user) { @user }
      should_respond_with :success
      should_not_set_the_flash
      should_render_template :show
    end
 
    context "on GET to :edit" do
      setup do
        get :edit, :id => @user.id
      end

      should_assign_to(:user) { @user }
      should_respond_with :success
      should_not_set_the_flash
      should_render_template :edit
    end
 
    context "on PUT to :update" do
      context "with successful update" do
        setup do
          User.any_instance.stubs(:update_attributes).returns(true)
          put :update, :id => @user.id, :user => { :email => "bill@example.com" }
        end

        should_assign_to(:user) { @user }
        should_respond_with :redirect
        should_set_the_flash_to "User was successfully updated."
        should_redirect_to("the user's account") { user_url(@user) }
      end

      context "with failed update" do
        setup do
          User.any_instance.stubs(:update_attributes).returns(false)
          put :update, :id => @user.id, :user => { :login => "bill" }
        end

        should_assign_to(:user) { @user }
        should_respond_with :success
        should_not_set_the_flash
        should_render_template :edit
      end
    end
  end
 
  context "with an admin user" do
    setup do
      @user = Factory.create(:user)
      controller.stubs(:user_required).returns(true)
      controller.stubs(:admin_required).returns(true)
    end

    context "on GET to :index" do              
      setup do                                 
        User.stubs(:all).returns([@user])      
        get :index                             
      end                                      
                                               
      should_assign_to(:users) { [@user] }     
      should_respond_with :success             
      should_render_template :index            
      should_not_set_the_flash                 
    end                                        
 
    context "on GET to :show" do
      setup do
        get :show, :id => @user.id
      end

      should_assign_to(:user) { @user }
      should_respond_with :success
      should_not_set_the_flash
      should_render_template :show
    end

    context "on GET to :new" do                           
      setup do                                            
        get :new                                          
      end                                                 
                                                          
      should_assign_to(:user)                   
      should_respond_with :success                        
      should_render_template :new                         
      should_not_set_the_flash                            
    end                                                   

    context "on POST to :create" do
      context "with successful creation" do
        setup do
          User.any_instance.stubs(:save).returns(true)
          post :create, :user => { :email => 'bob@example.com', :password => 'secret', 
                                   :password_confirmation => 'secret', :first_name => 'Bob', 
                                   :last_name => 'Smith' }
        end
    
        should_assign_to(:user)
        should_respond_with :redirect
        should_set_the_flash_to "User was successfully created."
      end
    
      context "with failed creation" do
        setup do
          User.any_instance.stubs(:save).returns(false)
          post :create, :user => { :email => "bobby", :password => "bobby", 
                                   :password_confirmation => "bobby" }
        end
    
        should_assign_to(:user)
        should_respond_with :success
        should_not_set_the_flash
        should_render_template :new
      end
    end
 
    context "on GET to :edit" do
      setup do
        get :edit, :id => @user.id
      end

      should_assign_to(:user) { @user }
      should_respond_with :success
      should_not_set_the_flash
      should_render_template :edit
    end
 
    context "on PUT to :update" do
      context "with successful update" do
        setup do
          User.any_instance.stubs(:update_attributes).returns(true)
          put :update, :id => @user.id, :user => { :first_name => "bill" }
        end

        should_assign_to(:user) { @user }
        should_respond_with :redirect
        should_set_the_flash_to "User was successfully updated."
        should_redirect_to("the user's account") { user_url(@user) }
      end

      context "with failed update" do
        setup do
          User.any_instance.stubs(:update_attributes).returns(false)
          put :update, :id => @user.id, :user => { :first_name => "bill" }
        end

        should_assign_to(:user) { @user }
        should_respond_with :success
        should_not_set_the_flash
        should_render_template :edit
      end
    end

    context "on DELETE to :destroy" do
      setup do
        delete :destroy, :id => @user.id
      end
 
      should_respond_with :redirect
      should_set_the_flash_to "User was deleted."
      should_redirect_to("the users page") { users_path }
    end
  end
end