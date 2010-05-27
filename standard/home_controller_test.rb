require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  context "with an authenticated user" do
    setup { controller.stubs(:user_required).returns(true) }

    context "on GET to :index" do
      setup { get :index }

      should_respond_with :success
      should_render_template :index
      should_not_set_the_flash
    end
  end

  context "without an authenticated user" do
    context "on GET to :index" do
      setup { get :index }

      should_respond_with :redirect
      should_set_the_flash_to /must be logged in/
    end
  end
end
