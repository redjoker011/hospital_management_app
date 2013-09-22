require 'spec_helper'

describe UserPatientsController do
  render_views

  describe "Redirect to login page if invalid user" do

    it ": unauthorized access to new should redirect to login" do
      get 'new', :id => 0, :type => 1
      response.should redirect_to(login_path)
    end

    it ": unauthorized creation of user_patient should redirect to login" do
      post 'create', :id => 0, :user_patient => {}
      response.should redirect_to(login_path)
    end

    it ": unauthorized access to edit page should redirect to login" do
      get 'edit', :id => 0, :type => 1
      response.should redirect_to(login_path)
    end

    it ": unathorized attempt to update user_patient record should redirect to login" do
      put 'update', :id => 0, :user_patient => {}
      response.should redirect_to(login_path)
    end
  end


  describe "Render  user patients pages" do

    before(:each) do
      @user = Factory(:user, :user_type_id => "1")
      @patient = Factory(:patient)
      test_sign_in(@user)
    end

    it ": must render new page in dialog through Ajax" do
      xhr :get, :new, :id => @patient, :type => 1
      response.should be_success
    end

    it ": must create new user patient intersection record" do
      params = {:amount => 100, :comment_type_id => 1, :comments => "abc abc abc", :user_id => @user.id, :patient_id => @patient.id}
      lambda do
        xhr :post, :create, :id => @patient, :user_patient => params
      end.should change(UserPatient, :count).by(1)
    end

  end

  describe "Must support other crud operations" do
    before(:each) do
      @user = Factory(:user, :user_type_id => "1")
      @user_patient = Factory(:user_patient)
      test_sign_in(@user)
    end

    it ": must render edit page in dialog through ajax" do
      xhr :get, :edit, :id => @user_patient
      response.should be_success
    end

    it ": must update the attributes of user_patient object" do
      params = {:comments => "abc1 abc1 abc1", :amount => 200}
      xhr :put, :update, :id => @user_patient, :user_patient => params
      @user_patient.reload
      @user_patient.comments.should eql params[:comments] and @user_patient.amount.should == params[:amount]
    end

    it ": must fetch user_patients records for given patients depending upon page no." do
       xhr :get, :fetch, :id => @user_patient.patient_id, :page => 2
       response.should be_success
    end

  end

end