class Api::BaseController < ApplicationController
  before_action :default_format_json
  before_action :authenticate

  private

  def default_format_json
    request.format = 'json'
  end

  def authenticate
    @current_user = SessionService.new.authenticate_token(params[:email], params[:auth_token])
  rescue SessionService::AuthenticationError
    render '404'
  end
end
