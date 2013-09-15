#Controller to monitor user treatment records such as prescription/medicines/surgeries.
class UserPatientsController < ApplicationController
  before_filter :authenticate

  #Action to render add prescription/medicines/surgery page in a dialog box through Ajax.
  # The page is rendered by new.js.erb, where doctor can enter prescription or surgery information for a patient.
  def new
      @patient = Patient.find(params[:id])
      @user_patient = UserPatient.new
      @user_patient.comment_type_id = params[:type];
      @user_patient.patient = @patient
      @user_patient.user = current_user
  end

  #Action to create prescription/medicine/surgery information corresponding to a patient in the database.
  def create
     @user_patient = UserPatient.create(params[:user_patient])
     if @user_patient.save
       @flashMessage = {:success => t(:patient_treatment, :scope => :messages)}
     else
       @flashMessage = {:error => t(:error_message, :scope => :messages)}
     end
  end

  #Action to display edit dialog to edit previously entered medical information.
  def edit
    @user_patient = UserPatient.find(params[:id])
  end

  #Action to update existing patient treatment information such as prescription/medicines/surgery
  # through edit feature.
  def update
    @user_patient = UserPatient.find(params[:id])
    if @user_patient.update_attributes(params[:user_patient])
      @flashMessage = {:success => t(:patient_treatment, :scope => :messages)}
    else
      @flashMessage = {:error => t(:error_message, :scope => :messages)}
    end
  end

  #Action to enable pagination of patient's treatment records on show patient page.
  def fetch
    @patient = Patient.find(params[:id])
    @user_patients = @patient.user_patients.reverse.paginate(:page => params[:page], :per_page => 5)
    puts @user_patients.first.amount
    respond_to do |format|
       format.js
      format.html
    end
  end
end
