class UserPatientsController < ApplicationController
  before_filter :authenticate

  def new
      @patient = Patient.find(params[:id])
      @user_patient = UserPatient.new
      @user_patient.comment_type_id = params[:type];
      @user_patient.patient = @patient
      @user_patient.user = current_user
  end

  def create
     @user_patient = UserPatient.create(params[:user_patient])
     if @user_patient.save
       @flashMessage = {:success => t(:patient_treatment, :scope => :messages)}
     else
       @flashMessage = {:error => t(:error_message, :scope => :messages)}
     end
  end

  def edit
    @user_patient = UserPatient.find(params[:id])
  end

  def update
    @user_patient = UserPatient.find(params[:id])
    if @user_patient.update_attributes(params[:user_patient])
      @flashMessage = {:success => t(:patient_treatment, :scope => :messages)}
    else
      @flashMessage = {:error => t(:error_message, :scope => :messages)}
    end
  end

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
