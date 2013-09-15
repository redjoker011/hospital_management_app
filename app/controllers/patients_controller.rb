class PatientsController < ApplicationController
  before_filter :authenticate

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.create(params[:patient])
    if @patient.save
      redirect_to @patient, :flash => {:success => t(:create_patient, :scope => :messages)}
    else
      render 'new'
    end
  end

  def show
    @patient =Patient.find(params[:id])
    @user_patients = @patient.user_patients.reverse.paginate(:page => params[:page], :per_page => 5)
    @enableInvoice = @patient.user_patients.where("archive is null").size
  end

  def index
    @patients = Patient.paginate(:page => params[:page])
  end

  def search
  end

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
end
