require 'spec_helper'

describe UsersController do
  render_views

  describe "User pages related tests - success tests" do
    before(:each) do
      @user = Factory(:user, :user_type_id => "1")
      test_sign_in(@user)
    end

    it ": must render create new user page" do
      get 'new'
      response.should be_success
    end

    it ": must render index page (show all)" do
      get 'index'
      response.should be_success
    end

    it ": must create user object" do
      params = {:first_name => "Shane", :last_name => "Watson", :email_id => "watson@hms.com", :user_type_id => "1", :password => "abc123", :password_confirmation => "abc123"}
      lambda do
        post :create, :user => params
      end.should change(User, :count)
    end

    it ": must show user details page" do
      get 'show', :id => @user
      response.should be_success
    end

    it ": must render edit page" do
      get :edit, :id => @user
      response.should be_success
    end

    it ": must update user details" do
      params = {:first_name => "Teddy", :last_name => "Mosbby", :email_id => "teddy@hms.com", :user_type_id => "1"}
      put :update, :id => @user, :user => params
      @user.reload
      @user.first_name.should == params[:first_name]
    end
  end

  describe "User pages related tests - Failed tests" do
    describe "Without proper User" do
        before(:each) do
          @user = Factory(:user, :user_type_id => "2")
        end

      it ": must redirect to login page if not logged in" do
        get 'new'
        response.should redirect_to(login_path)
      end

      it ": must redirect to login page if not logged in" do
        get 'index'
        response.should redirect_to(login_path)
      end

      it ": must redirect to login page if not logged in" do
        get :edit, :id => @user
        response.should redirect_to(login_path)
      end

      it ": must redirect to login page if not logged in" do
        get 'change_password', :id => @user
        response.should redirect_to(login_path)
      end

      it ": must not update and should redirect to login page" do
        params = {:first_name => "Teddy", :last_name => "Mosbby", :email_id => "teddy@hms.com", :user_type_id => "1"}
        put :update, :id => @user, :user => params
        response.should redirect_to(login_path)
      end
    end

    describe "Without admin privileges" do

      before(:each) do
        @user = Factory(:user, :user_type_id => "2")
        test_sign_in(@user)
      end

      it ": must redirect to user details page if not admin" do
        get 'new'
        response.should redirect_to(@user)
      end

      it ": must redirect to login page if not logged in" do
        get 'index'
        response.should redirect_to(@user)
      end
    end

    describe "correct user authorization" do
      before(:each) do
        @user1 = Factory(:user, :user_type_id => "2")
        @user2 = Factory(:user, :user_type_id => "3")
        test_sign_in(@user2)
      end

      it ": must redirect to his user details page if not a correct user" do
        get 'edit', :id => @user1
        response.should redirect_to(@user2)
      end

      it ": must redirect to his user details page if not a correct user" do
        get 'change_password', :id => @user1
        response.should redirect_to(@user2)
      end
    end
  end
end