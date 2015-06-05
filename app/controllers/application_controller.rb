class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :default_format_json
  before_action :authenticate

  private

  def authenticate
    SessionService.new.authenticate_token(params[:email], params[:auth_token])
  rescue SessionService::AuthenticationError
    return render 'shared/401', status: :unauthorized
  end

  def default_format_json
    request.format = 'json'
  end
end
