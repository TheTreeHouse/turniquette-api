require 'test_helper'

class RegistrationServiceTest < ActiveSupport::TestCase
  def setup
    @invitation = Invitation.create(email: 'johndoe@example.com')
    @user_data = { email: @invitation.email, password: 'my-password' }
  end

  def teardown
    Invitation.delete_all
    User.delete_all
  end

  test 'with valid invitation, creates a user' do
    assert_equal RegistrationService.new.from_invitation(@invitation.email, @invitation.token, @user_data).class, User
  end

  test 'with NOT valid invitation token, do nothing' do
    assert_equal RegistrationService.new.from_invitation(@invitation.email, 'faked-token', @user_data), nil
  end

  test 'with NOT valid invitation, do nothing' do
    assert_equal RegistrationService.new.from_invitation('fake@example.com', 'faked-token', @user_data), nil
  end
end
