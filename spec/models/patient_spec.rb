require 'spec_helper'

describe Patient do

  before(:each) do
    @patient_attributes = {
        :first_name => "robin",
        :last_name => "shoebasky",
        :email_id => "robin@patient.com",
        :phone => "27527",
        :date_of_birth => "22-09-2013"
    }
  end

  it ": should create new user object" do
    Patient.create!(@patient_attributes)
  end

  it ": first name is required" do
    test_patient = Patient.new(@patient_attributes.merge({:first_name => ""}))
    test_patient.should_not be_valid
  end

  it ": last name is required" do
    test_patient = Patient.new(@patient_attributes.merge({:last_name => ""}))
    test_patient.should_not be_valid
  end

  it ": email_id is required" do
    test_patient = Patient.new(@patient_attributes.merge({:email_id => ""}))
    test_patient.should_not be_valid
  end

  it ": email_id should be in correct format" do
    test_patient = Patient.new(@patient_attributes.merge({:email_id => "test"}))
    test_patient.should_not be_valid
  end

  it ": phone is required" do
    test_patient = Patient.new(@patient_attributes.merge({:phone => ""}))
    test_patient.should_not be_valid
  end

  it ": date of birth is required" do
    test_patient = Patient.new(@patient_attributes.merge({:date_of_birth => ""}))
    test_patient.should_not be_valid
  end

  describe "Test associations" do
    before(:each) do
      @patient = Patient.create!(@patient_attributes)
      @user_patient1 = Factory(:user_patient, :comments => "abc abc abc", :patient => @patient)
      @user_patient2 = Factory(:user_patient, :comments => "test test test", :patient => @patient)
    end

    it ": must have associated user_patient objects" do
      @patient.user_patients.size.should == 2
    end
  end
end