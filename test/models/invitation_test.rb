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
end
