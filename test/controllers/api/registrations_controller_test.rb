require 'test_helper'

class Api::RegistrationsControllerTest < ActionController::TestCase
  def setup
    Invitation.create(email: 'johndoe@example.com')
  end

  def teardown
    Invitation.delete_all
    User.delete_all
  end

  test 'create from invitation success' do
    invitation = Invitation.first
    user_data = { email: invitation.email, password: 'my-password' }
    user_number = User.count
    get :create, email: invitation.email, token: invitation.token, user_data: user_data

    assert_response :success
    assert_equal User.count, user_number + 1
    assert_equal response.body, '{"registration":{"success":true,"email":"johndoe@example.com"}}'
  end

  test 'create from invitation fail' do
    invitation = Invitation.first.tap { |item| item.token = 'faked-token' }
    user_data = { email: invitation.email, password: 'my-password' }
    user_number = User.count
    get :create, email: invitation.email, token: invitation.token, user_data: user_data

    assert_response :success
    assert_equal User.count, user_number
    assert_equal response.body, '{"registration":{"success":false}}'
  end
end
