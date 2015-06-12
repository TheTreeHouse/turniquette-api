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
    assert_equal ['is already taken'], event_duplicated.errors[:name]
  end

  test 'requires name' do
    @event.name = nil
    assert_not @event.valid?
    assert_equal ["can't be blank"], @event.errors[:name]
  end

  test 'requires date' do
    @event.date = nil
    assert_not @event.valid?
    assert_equal ["can't be blank"], @event.errors[:date]
  end

  test 'requires an owner when is created' do
    event_without_owner = Event.new(name: "Krusty's birthday party", date: Time.zone.now)
    assert_not event_without_owner.valid?
    assert_equal ["can't be blank"], event_without_owner.errors[:owner]
  end

  test 'does not require an owner when is updated' do
    @event.owner = nil
    assert @event.valid?
  end
end
