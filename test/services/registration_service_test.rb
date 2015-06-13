require 'test_helper'

class RegistrationServiceTest < ActiveSupport::TestCase
  def setup
    @event = Event.create(name: "Moe's bar", date: Time.zone.now)
    @invitation = Invitation.create(event: @event, email: 'johndoe@example.com')
    @user_data = { email: @invitation.email, password: 'my-password' }
  end

  def teardown
    Event.delete_all
    Invitation.delete_all
    User.delete_all
  end

  test 'with valid invitation, creates a user' do
    assert_equal RegistrationService.new.from_invitation(@invitation.email, @invitation.token, @user_data).class, User
  end

  test 'with valid invitation & existing user, does not create a new user' do
    User.create(@user_data)
    assert_no_difference 'User.count' do
      RegistrationService.new.from_invitation(@invitation.email, @invitation.token, @user_data)
    end
  end

  test 'with valid invitation, removes invitation' do
    assert_difference 'Invitation.count', -1 do
      RegistrationService.new.from_invitation(@invitation.email, @invitation.token, @user_data)
    end
  end

  test 'with NOT valid invitation token, do nothing' do
    assert_raise RegistrationService::InvalidInvitationError do
      RegistrationService.new.from_invitation(@invitation.email, 'faked-token', @user_data)
    end
  end

  test 'with NOT valid invitation, do nothing' do
    assert_raise RegistrationService::InvalidInvitationError do
      RegistrationService.new.from_invitation('fake@example.com', 'faked-token', @user_data)
    end
  end
end
