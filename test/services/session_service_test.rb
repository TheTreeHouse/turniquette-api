require 'test_helper'

class SessionServiceTest < ActiveSupport::TestCase
  def setup
    User.create(email: 'johndoe@example.com', password: 'secret')
  end

  def teardown
    User.delete_all
  end

  test 'email not exist returns nil' do
    user = User.first
    session = SessionService.new.authenticate('wrong-email@example.com', 'secret')
    assert_nil session
  end

  test 'wrong password returns nil' do
    user = User.first
    session = SessionService.new.authenticate(user.email, 'wrong-password')
    assert_nil session
  end

  test 'valid authentication returns a User' do
    user = User.first
    session = SessionService.new.authenticate(user.email, 'secret')
    assert_equal User, session.class
  end

  test 'valid authentication creates an auth_token' do
    user = User.first
    session = SessionService.new.authenticate(user.email, 'secret')
    assert_not_nil session.auth_token
  end

  test 'destroy' do
    user = User.first
    session = SessionService.new.destroy(user.email)
    assert_nil session.auth_token
  end
end
