require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def teardown
    User.delete_all
  end

  test 'requires email' do
    user = User.new
    assert_not user.valid?
    assert_equal ["can't be blank"], user.errors[:email]
  end

  test 'does not allow more than one user with same email' do
    User.create(email: 'homer@simpsons.com')
    user_duplicated = User.new(email: 'homer@simpsons.com')
    assert_not user_duplicated.valid?
    assert_equal ['is already taken'], user_duplicated.errors[:email]
  end
end
