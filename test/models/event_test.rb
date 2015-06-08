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
end
