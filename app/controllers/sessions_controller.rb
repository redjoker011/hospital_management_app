#Session management controller for the application.

class SessionsController < ApplicationController

  #Action to render index page of the application.
  def login
    @page_name = SessionsHelper::LOGIN;
  end

  #Action to create session for the user if authentication succeeds.
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

  #Action to destroy session on user logout.
  def destroy
    sign_out
    redirect_to login_path
  end
end
