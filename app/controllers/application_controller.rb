class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  rescue_from Mongoid::Errors::Validations, with: :show_error

  before_action :default_format_json
  before_action :authenticate

  private

  def show_error(exception)
    render partial: 'shared/validation_error', locals: { model: exception.record }, status: :forbidden
  end

  def authenticate
    @current_user ||= SessionService.new.authenticate_token(params[:email], params[:auth_token])
  rescue SessionService::AuthenticationError
    return render 'shared/401', status: :unauthorized
  end

  def default_format_json
    request.format = 'json'
  end
end
