class V1::RegistrationsController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    email, token, user_data = params[:email], params[:token], params[:user_data]
    @user = RegistrationService.new.from_invitation(email, token, user_data)
    render 'v1/session'
  rescue RegistrationService::InvalidInvitationError
    render 'shared/404', status: :not_found
  end
end
