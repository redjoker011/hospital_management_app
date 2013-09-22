require 'spec_helper'

describe PatientsController do
  render_views

  describe "dont render any patient page" do
    it ": Dont render new page, if user not logged in redirect to login" do
        get 'new'
        response.should redirect_to(login_path)
    end

    it ": Dont create patient, if user not logged in redirect to login" do
      post :create, :patient => {}
      response.should redirect_to(login_path)
    end

    it ": Dont render show page, if user not logged in redirect to login" do
      get 'show', :id => 0
      response.should redirect_to(login_path)
    end

    it ": Dont show index page, if user not logged in" do
      get 'index'
      response.should redirect_to(login_path)
    end
  end

  describe "Patients render related pages" do
    before(:each) do
      @user = Factory(:user, :user_type_id => "1")
      @patient = Factory(:patient)
      test_sign_in(@user)
    end

    it ": must render new page" do
      get 'new'
      response.should be_success
    end

    it ": must render show all page" do
      get 'index'
      response.should be_success
    end

    it ": must render new page" do
      get 'show', :id => @patient
      response.should be_success
    end

    it ": must create a patient" do
      params = {:first_name => "Jaspal", :last_name => "Bhatti", :email_id => "jaspal@patient.com", :phone => "2873652", :date_of_birth => "08-08-1987"}
      lambda do
        post :create, :patient => params
      end.should change(Patient, :count)
    end

    it ": must render search page" do
      get 'search'
      response.should be_success
    end

    it ": must fetch search results using Ajax" do
      params = {:first_name => "Akshay", :last_name => "Joshi", :email_id => "akshay@patient.com", :patient_id => ""}
      xhr :post, :searchPatients, :patient => params
      response.should be_success
    end
  end
end