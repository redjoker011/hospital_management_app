require 'spec_helper'

describe UserPatient do
  before(:each) do
    @user = Factory(:user)
    @patient = Factory(:patient)
    @user_patient_attributes = {
        :amount => 350,
        :comment_type_id => 1,
        :comments => "paracetamol prescribed",
        :patient_id => @patient.id,
        :user_id => @user.id
    }
  end

  it ": must create user_patient" do
     UserPatient.create!(@user_patient_attributes)
  end
end