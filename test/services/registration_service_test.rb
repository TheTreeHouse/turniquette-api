require 'test_helper'

class RegistrataionServiceTest < ActiveSupport::TestCase
  def setup
    @invitation = Invitation.create(email: 'johndoe@example.com')
  end

  def teardown
    Invitation.delete_all
    User.delete_all
  end

  test 'with valid invitation, creates a user' do
    user_data = { email: @invitation.email, password: 'my-password' }
    assert_equal RegistrationService.new.from_invitation(@invitation.email, @invitation.token, user_data).class, User
  end

  test 'with NOT valid invitation token, do nothing' do
    user_data = { email: @invitation.email, password: 'my-password' }
    assert_equal RegistrationService.new.from_invitation(@invitation.email, 'faked-token', user_data), nil
  end

  test 'with NOT valid invitation, do nothing' do
    faked_email = 'fake@example.com'
    faked_token = 'faked-token'
    user_data = { email: faked_email, password: 'my-password' }
    assert_equal RegistrationService.new.from_invitation(faked_email, faked_token, user_data), nil
  end
end
