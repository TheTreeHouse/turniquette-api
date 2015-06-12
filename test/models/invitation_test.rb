require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: 'homer@simpsons.com')
    @event = Event.create(name: "Moe's bar", date: Time.zone.now, owner: @user)
  end

  def teardown
    Event.delete_all
    Invitation.delete_all
  end

  test 'Invitation sends an email after creation' do
    assert_difference 'ActionMailer::Base.deliveries.size' do
      Invitation.create(event: @event, email: 'new_user@example.com')
    end
  end

  test 'Delete cascade on Event.delete' do
    2.times { |number| Invitation.create(event: @event, email: "new_user#{ number }@example.com") }
    assert_difference 'Invitation.count', -2 do
      @event.destroy
    end
  end

  test 'requires email' do
    invitation = Invitation.new
    assert_not invitation.valid?
    assert_equal ["can't be blank"], invitation.errors[:email]
  end

  test 'allows invitations sharing email for different events' do
    invitation = Invitation.create(event: @event, email: 'invited@email.com')
    alt_event = Event.new(name: 'Different event', owner: @user, date: Time.zone.now)
    new_invitation = Invitation.new(event: alt_event, email: 'invited@email.com')

    assert new_invitation.valid?
  end

  test 'does not allow invitation sharing email for same event' do
    invitation = Invitation.create(event: @event, email: 'invited@email.com')
    new_invitation = Invitation.new(event: @event, email: 'invited@email.com')

    assert_not new_invitation.valid?
    assert_equal ['is already taken'], new_invitation.errors[:email]
  end
end
