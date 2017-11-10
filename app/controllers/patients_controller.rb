#Controller responsible for monitoring all patient related activities.

class PatientsController < ApplicationController
  before_action :authenticate

  #Action method to show create page with empty patient object initialized.
  def new
    @patient = Patient.new
  end

  #Action to save the patient object as per data entered on the new page.
  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      redirect_to @patient, :flash => {:success => t(:create_patient, :scope => :messages)}
    else
      render 'new'
    end
  end

  #Action to find patient by patient_id and set it as instance variable so that it can be displayed
  #on the show page. Also finds all the corresponding medical treatments records for the patient
  def show
    @patient =Patient.find(params[:id])
    @user_patients = @patient.user_patients.reverse.paginate(:page => params[:page], :per_page => 5)
    @enableInvoice = @patient.user_patients.where("archive is null").size
  end

  #default page to show all users registered for this application.
  def index
    @patients = Patient.paginate(:page => params[:page])
  end

  #action to render search page to enable patient search feature.
  def search
  end

  #Action to search patient by first_name or last_name or email_id or id (ajax method which executes default js)
  def searchPatients
    search_by_first_name = params[:patient][:first_name]
    search_by_last_name = params[:patient][:last_name]
    search_by_id = params[:patient][:patient_id]
    search_by_email_id = params[:patient][:email_id]
    sql = String.new

    if !search_by_id.blank?
          sql = "id = " + search_by_id
    end
    if !search_by_email_id.blank?
          if sql.blank?
            sql += "email_id like '%"+ search_by_email_id + "%'"
          else
            sql += " or email_id like '%"+ search_by_email_id + "%'"
          end
    end
    if !search_by_first_name.blank?
       if sql.blank?
         sql += "first_name like '%"+ search_by_first_name + "%'"
       else
         sql += " or first_name like '%"+ search_by_first_name + "%'"
       end
    end

    if !search_by_last_name.blank?
      if sql.blank?
        sql += "last_name like '%"+ search_by_last_name + "%'"
      else
        sql += " or last_name like '%"+ search_by_last_name + "%'"
      end
    end

    if !sql.blank?
      @patients = Patient.where(sql).paginate(:page => params[:page], :per_page => 5)
    end
  end


  #Action to generate invoice pdf for a patient and mark all the patient records as archive. Since
  #invoice is generated upon discharge of a patient. Makes use of HmsPdfDocument to generate the pdf's.
  def generate_invoice
    @patient = Patient.find(params[:id])
    @user_patients  = @patient.user_patients.where("archive is null")
    respond_to do |format|
      format.html
      format.pdf do
        pdf = HmsPdfDocument.new(SessionsHelper::FOR_PATIENT, @user_patients, view_context)
        @user_patients.update_all :archive => SessionsHelper::ARCHIVE
        send_data pdf.render, filename: "invoice_summary_#{@patient.id}.pdf", type: "application/pdf"
      end
    end
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :date_of_birth, :phone, :email_id)
  end
end
