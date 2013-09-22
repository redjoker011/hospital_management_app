require 'spec_helper'

describe SessionsController do
    render_views

    describe "Session pages related tests" do
      it ": must render login page when accessed" do
        get 'login'
        response.should be_success
      end

      it ": must have application name as title (Hospital Management System)" do
        get 'login'
        response.should have_selector("title", :content => "Hospital Management System")
      end

      it ": must log into application" do
        params = {:email_id => "admin@hms.com", :password => "abc123"}
        put :create, :session => params
        controller.should be_has_signed
      end

      it ": must not login with invalid username and password" do
        params = {:email_id => "test@test.com", :password => "testtesttest"}
        put :create, :session => params
        controller.should_not be_has_signed
      end

      it ": must sign out a logged in user" do
        test_sign_in(Factory(:user))
        delete :destroy
        controller.should_not be_has_signed
        response.should redirect_to(login_path)
      end
    end
end