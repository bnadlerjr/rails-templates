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
    should "call block if the current user is logged in and an admin" do
      self.stubs(:admin_logged_in?).returns(true)
      assert_equal "result", admin_only { "result" }
    end
 
    should "not call the supplied block if the current user is anonymous" do
      self.stubs(:admin_logged_in?).returns(false)
      assert_nil admin_only { "result" }
    end
 
    should "not call block if the current user is logged in but not admin" do
      self.stubs(:logged_in?).returns(true)
      self.stubs(:admin_logged_in?).returns(false)
      assert_nil admin_only { "result" }
    end
  end

  context "flash helpers" do
    should "render the flash" do
      self.stubs(:flash).returns({ :notice => 'Test message.' })
      assert_equal "<div id=\"flash\">" +
                   "<p class=\"notice\">Test message.</p></div>", render_flash
    end

    should "return nil if flash is nil" do
      self.stubs(:flash).returns(nil)
      assert_nil render_flash
    end

    should "return nil if flash is empty" do
      self.stubs(:flash).stubs("empty?").returns(true)
      assert_nil render_flash
    end
  end

  context "error helper" do
    setup { @obj = Object.new }

    should "show all errors" do
      errors = [1, 2, 3]
      errors.stubs(:full_messages).returns(['Error 1', 'Error 2', 'Error 3'])
      @obj.stubs(:errors).returns(errors)
      assert_equal "<div class=\"error\">" +
                   "<p>There were some errors when trying to save:</p>" +
                   "<ol class=\"disc\">" +
                   "<li>Error 1</li><li>Error 2</li><li>Error 3</li>" +
                   "</ol></div>", errors_for(@obj)
    end

    should "show single error" do
      errors = [1]
      errors.stubs(:full_messages).returns('Error 1')
      @obj.stubs(:errors).returns(errors)
      assert_equal "<div class=\"error\">" +
                   "<p>There was an error when trying to save:</p>" +
                   "<ol class=\"disc\"><li>Error 1</li></ol></div>", 
                   errors_for(@obj)
    end

    should "return nil if there are no errors" do
      @obj.stubs(:errors).returns(Array.new)
      assert_nil errors_for(@obj)
    end
  end
end
