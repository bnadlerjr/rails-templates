require 'test_helper'
 
class ApplicationHelperTest < ActionView::TestCase
  context "anonymous_only" do
    should "call the supplied block if the current user is anonymous" do
      self.stubs(:logged_in?).returns(false)
      assert_equal "result", anonymous_only { "result" }
    end
 
    should "not call the supplied block if the current user is logged in" do
      self.stubs(:logged_in?).returns(true)
      assert_nil anonymous_only { "result" }
    end
  end

  context "authenticated_only" do
    should "call the supplied block if the current user is logged in" do
      self.stubs(:logged_in?).returns(true)
      assert_equal "result", authenticated_only { "result" }
    end
 
    should "not call the supplied block if the current user is anonymous" do
      self.stubs(:logged_in?).returns(false)
      assert_nil authenticated_only { "result" }
    end
  end

  context "admin_only" do
    should "call the supplied block if the current user is logged in and an admin" do
      self.stubs(:admin_logged_in?).returns(true)
      assert_equal "result", admin_only { "result" }
    end
 
    should "not call the supplied block if the current user is anonymous" do
      self.stubs(:admin_logged_in?).returns(false)
      assert_nil admin_only { "result" }
    end
 
    should "not call the supplied block if the current user is logged in but not an admin" do
      self.stubs(:logged_in?).returns(true)
      self.stubs(:admin_logged_in?).returns(false)
      assert_nil admin_only { "result" }
    end
  end
end