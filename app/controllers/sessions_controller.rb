class SessionsController < ApplicationController
  def login
    @page_name = SessionsHelper::LOGIN;
  end

  def create
    user = User.authenticate(params[:session][:email_id], params[:session][:password])
    if user
      reset_session
      sign_in(user)
      redirect_to user
    else
      render 'login'
    end
  end

  def destroy
    sign_out
    redirect_to login_path
  end
end
