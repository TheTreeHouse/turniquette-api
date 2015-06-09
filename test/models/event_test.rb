require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: 'homer@simpsons.com', password: 'any-key', auth_token: 'stupid-flanders')
    @event = Event.create(name: "Moe's bar", date: Time.zone.now, owner: @user)
  end

  def teardown
    Event.delete_all
    User.delete_all
  end

  test 'set nil when the owner is deleted' do
    @user.destroy
    assert_nil @event.owner
  end

  test 'allows repeated event names for different owners' do
    owner = User.new(email: 'homero@simpsons.com')
    event_duplicated = Event.new(name: "Moe's bar", owner: owner, date: Time.zone.now)
    assert event_duplicated.valid?
  end

  test 'does not allow repeated event names for same owner' do
    event_duplicated = Event.new(name: "Moe's bar", owner: @user, date: Time.zone.now)
    assert_not event_duplicated.valid?
  end
end
