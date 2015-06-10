require 'test_helper'

class V1::InvitationsControllerTest < ActionController::TestCase
  def setup
    @user = User.create(email: 'johndoe@example.com', password: 'secret', auth_token: 'secret-token')
    @event = Event.create(owner: @user)
    @auth_params = { email: @user.email, auth_token: @user.auth_token }
  end

  def teardown
    User.delete_all
    Event.delete_all
    Invitation.delete_all
  end

  test 'create invitations' do
    email_list = %w(new_user1@example.com new_user2@example.com new_user3@example.com)
    assert_difference 'Invitation.count', email_list.size do
      get :create, { event: @event.id, email_list: email_list }.merge!(@auth_params)
    end

    assert_response :success
    expected_body = "{\"success\":true,\"event\":\"#{ @event.id }\",\"invitationNumber\":#{ email_list.size }}"
    assert_equal response.body, expected_body
  end

  test 'fail sending inexistent event' do
    assert_no_difference 'Invitation.count' do
      get :create, { event: 'none', email_list: ['new_user@example.com'] }.merge!(@auth_params)
    end
    assert_response :not_found
  end
end
