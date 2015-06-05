require 'test_helper'

class SessionServiceTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: 'johndoe@example.com', password: 'secret')
  end

  def teardown
    User.delete_all
  end

  test 'email not exist returns nil' do
    assert_raise SessionService::AuthenticationError do
      SessionService.new.authenticate('wrong-email@example.com', 'secret')
    end
  end

  test 'wrong password returns nil' do
    assert_raise SessionService::AuthenticationError do
      SessionService.new.authenticate(@user.email, 'wrong-password')
    end
  end

  test 'valid authentication returns a User' do
    session = SessionService.new.authenticate(@user.email, 'secret')
    assert_equal @user, session
  end

  test 'valid authentication creates an auth_token' do
    session = SessionService.new.authenticate(@user.email, 'secret')
    assert_not_nil session.auth_token
  end

  test 'destroy' do
    session = SessionService.new.destroy(@user.email)
    assert_nil session.auth_token
  end
end
