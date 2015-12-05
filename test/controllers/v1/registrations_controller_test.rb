require 'test_helper'

class V1::RegistrationsControllerTest < ActionController::TestCase
  include RegistrationSetup

  test 'create from invitation success' do
    assert_difference 'User.count' do
      get :create, email: @invitation.email, token: @invitation.token, user_data: @user_data
    end
    assert_response :success
    assert_equal response.body, '{"success":true,"email":"johndoe@example.com"}'
  end

  test 'create from invitation fail' do
    assert_no_difference 'User.count' do
      get :create, email: @invitation.email, token: 'faked-token', user_data: @user_data
    end
    assert_response :not_found
    assert_equal response.body, '{"success":false,"message":"Not found"}'
  end
end
