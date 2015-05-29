require 'test_helper'

class V1::SessionsControllerTest < ActionController::TestCase
  def setup
    @user = User.create(email: 'johndoe@example.com', password: 'secret')
  end

  def teardown
    User.delete_all
  end

  test 'login success' do
    get :create, email: @user.email, password: 'secret'

    assert_response :success
    assert_not_nil @user.reload.auth_token
    expected_body = '{"success":true,"email":"johndoe@example.com","auth_token":"' + @user.auth_token + '"}'
    assert_equal response.body, expected_body
  end

  test 'login fail' do
    get :create, email: @user.email, password: 'wrong-password'

    assert_response :unauthorized
    assert_equal response.body, '{"success":false,"message":"Authentication error"}'
  end

  test 'logout success' do
    @user.update_attribute(:auth_token, 'secret-token')
    get :destroy, email: @user.email, auth_token: @user.auth_token

    assert_response :success
    assert_nil @user.reload.auth_token
    assert_equal response.body, '{"success":true,"email":"johndoe@example.com"}'
  end

  test 'logout fail' do
    @user.update_attribute(:auth_token, 'secret-token')
    get :destroy, email: @user.email, auth_token: 'wrong-token'

    assert_response :unauthorized
    assert_not_nil @user.reload.auth_token
    assert_equal response.body, '{"success":false,"message":"Authentication error"}'
  end
end
