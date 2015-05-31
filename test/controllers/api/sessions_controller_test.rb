require 'test_helper'

class Api::SessionsControllerTest < ActionController::TestCase
  def setup
    @user = User.create(email: 'johndoe@example.com', password: 'secret')
  end

  def teardown
    User.delete_all
  end

  test 'login success' do
    user = User.first
    get :create, email: user.email, password: 'secret'

    assert_response :success
    assert_not_empty user.reload.auth_token
    assert_equal response.body, '{"session":{"success":true,"email":"johndoe@example.com","auth_token":"' + user.auth_token + '"}}'
  end

  test 'login fail' do
    get :create, email: @user.email, password: 'wrong-password'

    assert_response :success
    assert_equal response.body, '{"session":{"success":false}}'
  end

  test 'logout success' do
    get :destroy, email: @user.email, auth_token: @user.auth_token

    assert_response :success
    assert_equal response.body, '{"session":{"success":true,"email":"johndoe@example.com","auth_token":null}}'
  end

  test 'logout fail' do
    get :destroy, email: @user.email, auth_token: 'wrong-token'

    assert_response :success
    assert_not_nil @user.auth_token
    assert_equal response.body, '{"session":{"success":false,"message":"Authentication error"}}'
  end
end
