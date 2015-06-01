class V1::RegistrationsController < ApplicationController
  def create
    email, token, user_data = params[:email], params[:token], params[:user_data]
    @user = RegistrationService.new.from_invitation(email, token, user_data)
  end
end
