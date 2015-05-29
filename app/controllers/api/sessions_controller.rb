class Api::SessionsController < Api::BaseController
  skip_before_filter :authenticate, only: [:create]

  def create
    email, password = params[:email], params[:password]
    @user = SessionService.new.authenticate(email, password)
  end

  def destroy
    @user = SessionService.new.destroy(params[:email])
  end
end
