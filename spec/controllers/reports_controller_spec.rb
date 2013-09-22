require 'spec_helper'

describe ReportsController do
  render_views

  describe "Unauthenticated access redirect to login" do
    it ": must redirect to login if admin reports page is accessed" do
      get 'reports'
      response.should redirect_to(login_path)
    end

    it ": must redirect to login if my reports page is accessed" do
      get 'my_reports'
      response.should redirect_to(login_path)
    end
  end

  describe "Authorized access" do
    it ": must not allow user to access admin reports page" do
      @user = Factory(:user, :user_type_id => "2")
      test_sign_in(@user)
      get 'reports'
      response.should redirect_to(@user)
    end
  end

  describe "Test functional reports for admin" do
    before(:each) do
      @user = Factory(:user, :user_type_id => 1)
      test_sign_in(@user)
    end

    it ": render reports page" do
      get 'reports', :type => "STAFF"
      response.should be_success
    end

    it ": fetch reports for user" do
      params = {:user_id => @user.id, :treatment_id => 1, :from_date => "08-08-2013", :to_date => "22-09-2013"}
      xhr :post, :fetch_reports, :report => params
      response.should be_success
    end
  end

  describe "Test functional reports for normal user" do
    before(:each) do
      @user = Factory(:user, :user_type_id => 2)
      test_sign_in(@user)
    end

    it ": render reports page" do
      get 'my_reports'
      response.should be_success
    end

    it ": fetch reports for user" do
      params = {:user_id => @user.id, :treatment_id => 1, :from_date => "08-08-2013", :to_date => "22-09-2013"}
      xhr :post, :fetch_reports, :report => params
      response.should be_success
    end
  end

end