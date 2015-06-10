require 'test_helper'

class V1::EventsControllerTest < ActionController::TestCase
  def setup
    @logged_user = User.create(email: 'homer@simpsons.com', password: 'any-key', auth_token: 'stupid-flanders')
    @logged_event = Event.create(name: "Moe's bar", date: Time.zone.now, owner: @logged_user)
    @other_event = Event.create(name: 'Treehouse', date: Time.zone.now, owner: User.new(email: 'user@email.com'))
    @auth_params = { email: @logged_user.email, auth_token: @logged_user.auth_token }
  end

  def teardown
    Event.delete_all
    User.delete_all
  end

  test 'list all owned events' do
    get :index, @auth_params
    assert_response :success
    assert_equal assigns(:events), [@logged_event]
  end

  test 'show an owned event' do
    get :show, { id: @logged_event }.merge!(@auth_params)
    assert_response :success
    assert_equal assigns(:event), @logged_event
  end

  test 'do NOT show a non-owned event' do
    get :show, { id: @other_event }.merge!(@auth_params)
    assert_response :not_found
  end

  test 'create new event' do
    assert_difference 'Event.count' do
      get :create, { name: 'event', date: Time.zone.now, owner: @logged_user }.merge!(@auth_params)
    end
    assert_response :success
  end

  test 'update an owned event' do
    patch :update, { id: @logged_event, name: 'changed' }.merge!(@auth_params)
    assert_response :success
  end

  test 'do NOT update a non-owned event' do
    patch :update, { id: @other_event, name: 'changed' }.merge!(@auth_params)
    assert_response :not_found
  end

  test 'destroy an owned event' do
    assert_difference 'Event.count', -1 do
      delete :destroy, { id: @logged_event }.merge!(@auth_params)
    end
    assert_response :success
  end

  test 'do NOT destroy a non-owned event' do
    assert_no_difference 'Event.count' do
      delete :destroy, { id: @other_event }.merge!(@auth_params)
    end
    assert_response :not_found
  end

  test "alert when trying to create an invalid event" do
    missing_name = { date: Time.zone.now, owner: @logged_user }
    assert_no_difference 'Event.count' do
      get :create, missing_name.merge!(@auth_params)
    end
    assert_response :forbidden
    assert_equal response.body, %Q({"success":false,"message":["Name can't be blank"]})
  end

  test "alerte when trying to update an event with invalid data" do
    patch :update, { id: @logged_event, name: '' }.merge!(@auth_params)
    assert_response :forbidden
    assert_equal response.body, %Q({"success":false,"message":["Name can't be blank"]})
  end
end
