#This controller is responsible for creation/updation of the Users.

class UsersController < ApplicationController
  before_action :authenticate
  before_action :correct_user, :only => [:edit, :update, :change_password, :update_password]
  before_action :authenticate_admin, :only => [:create, :index, :new]

  #Action to render add user page.
  def new
    @user = User.new
    getUserTypes
  end

  #Default action to display all users registered with the application.
  def index
     @users = User.paginate(:page => params[:page])
  end

  #Action to create new user based on the credentials supplied by new page.
  def create
    @user = User.create(params[:user])
    if @user.save
      redirect_to @user, :flash => {:success => t(:create_user, :scope => :messages)}
    else
      getUserTypes
      render 'new'
    end
  end

  #Action to display user information.
  def show
    @user = User.find(params[:id])
  end

  #Renders password change page, which enable users to change their password.
  def change_password
   @user = User.find(params[:id])
  end

  #Action to update changed password into the database.
  def update_password
    @user = User.find(params[:id])
    if ((params[:user][:password]).blank? || (params[:user][:password_confirmation]).blank?)
      @user.errors[:base] = t(:password_blank, :scope => :messages)
      render 'change_password'
    elsif ((params[:user][:password]) != (params[:user][:password_confirmation]))
      @user.errors[:base] = t(:password_mismatch, :scope => :messages)
      render 'change_password'
    elsif @user.update_attribute(:password, params[:user][:password])
      sign_in @user
      redirect_to @user, :flash => {:success => t(:updated, :scope => :messages)}
    else
      render 'change_password'
    end
  end

  #Renders edit user page to edit personal information.
  def edit
      @user = User.find(params[:id])
      getUserTypes
  end

  #Action to update edited personal information of user in database.
  def update
     @user = User.find(params[:id])
     if @user.update_attributes(params[:user])
      redirect_to @user, :flash => {:success => t(:updated, :scope => :messages)}
     else
       getUserTypes
       render 'edit'
     end
  end


  private

  #private method to pre-populate different types of users such as ADMIN, DOCTOR, STAFF.
  def getUserTypes
    @user_types = UserType.all.map {|ut| [ut.user_type_name, ut.id]}
  end
end
