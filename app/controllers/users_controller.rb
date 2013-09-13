class UsersController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [:edit, :update, :change_password, :update_password]
  before_filter :authenticate_admin, :only => [:create, :index, :new]

  def new
    @user = User.new
    getUserTypes
  end

  def index
     @users = User.paginate(:page => params[:page])
  end

  def create
    @user = User.create(params[:user])
    if @user.save
      redirect_to @user, :flash => {:success => t(:create_user, :scope => :messages)}
    else
      getUserTypes
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def change_password
   @user = User.find(params[:id])
  end

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

  def edit
      @user = User.find(params[:id])
      getUserTypes
  end

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

  def getUserTypes
    @user_types = UserType.all.map {|ut| [ut.user_type_name, ut.id]}
  end
end
