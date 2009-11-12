require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context 'a user instance' do
    setup { @user = Factory.create(:user) }

    should 'return a full name' do
      assert_equal('John Doe', @user.full_name)
    end

    should 'return a short name' do
      assert_equal('John D.', @user.short_name)
    end
  end
end