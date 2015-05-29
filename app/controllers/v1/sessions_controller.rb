class V1::SessionsController < ApplicationController
  skip_before_filter :authenticate, only: [:create]

  def create
    @user = SessionService.new.authenticate(params[:email], params[:password])
    render 'v1/session'
  rescue SessionService::AuthenticationError
    render 'shared/401', status: :unauthorized
  end

  def destroy
    @user = SessionService.new.destroy(params[:email])
    render 'v1/session'
  end
end
