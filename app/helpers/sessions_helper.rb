module SessionsHelper

  #constants
  ADMIN = "ADMIN"
  STAFF = "STAFF"
  DOCTOR = "DOCTOR"
  LOGIN = "login"
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  FOR_PATIENT = "FOR_PATIENT"
  FOR_STAFF = "FOR_STAFF"
  FOR_DOCTOR = "FOR_DOCTOR"
  ARCHIVE = "A"

  def sign_in(user)
    session[:user_id] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    return current_user == user
  end

  def has_signed?
    if(self.current_user.blank? || self.current_user == nil)
      return false
    else
      return true
    end
  end

  def current_user
    @current_user = remember_from_session
  end

  def sign_out
    reset_session
    self.current_user = nil
  end

  def deny_access
    redirect_to login_path, :flash => {:notice => t(:login_access, :scope => :messages)}
  end

  def authenticate
    deny_access unless has_signed?
  end

  def authenticate_admin
    if(has_signed? == false)
      deny_access
    elsif (!current_user.blank? && current_user.user_type.user_type_name != SessionsHelper::ADMIN)
      redirect_to current_user, :flash => {:notice => t(:unauthorized_access, :scope => :messages)}
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to current_user, :flash => {:notice => t(:unauthorized_access, :scope => :messages)} unless current_user?(@user)
  end

  private

  def remember_from_session
    User.authenticate_with_salt(session[:user_id])
  end
end
