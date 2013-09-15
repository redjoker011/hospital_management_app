#This controller is responsible for reports generation and exporting the same as pdf documents.

class ReportsController < ApplicationController

  #Enable authentication for this page by using SessionsHelper's authenticate and authenticate_admin.
  before_filter :authenticate
  before_filter :authenticate_admin, :only => [:reports]

  #Action to render reports default page for the admin user,
  # it pre-populates required data on the reports page such as users,
  # comment types - by calling private method pre_populate_reports
  def reports
    @user_type = UserType.find_by_user_type_name(params[:type])
    if @user_type.user_type_name == SessionsHelper::STAFF
      @user_type_admin = UserType.find_by_user_type_name(SessionsHelper::ADMIN)
      @users = User.where("user_type_id = ? or user_type_id = ?", @user_type.id, @user_type_admin.id)
    else
      @users = User.find_all_by_user_type_id(@user_type.id)
    end
    pre_populate_reports
    @type = params[:type]
  end

  #Action to render default reports page to a STAFF/DOCTOR type user.
  # Utilizes, pre_populate_reports to pre-populate required data on the page.
  def my_reports
    @my_reports = true
    pre_populate_reports
    render 'reports'
  end

  #Action to server actual reports based on filter parameters. common for all types of Users.
  def fetch_reports
    search_by_user_id = params[:report][:user_id]
    search_by_treatment_type = params[:report][:treatment_id]
    search_by_from_date = params[:report][:from_date]
    search_by_to_date = params[:report][:to_date]
    sql = "user_id = :user_id and DATE(created_at) between :from_date and :to_date"

    from_date = Date.parse(search_by_from_date)
    to_date = Date.parse(search_by_to_date)

    if !sql.blank?
      if search_by_treatment_type != "0"
        sql += " and comment_type_id = :comment_type_id"
        @user_patients = UserPatient.where(sql, {:user_id => search_by_user_id, :comment_type_id => search_by_treatment_type, :from_date => from_date, :to_date => to_date}).paginate(:page => params[:page], :per_page => 5)
      else
        @user_patients = UserPatient.where(sql, {:user_id => search_by_user_id, :from_date => from_date, :to_date => to_date}).paginate(:page => params[:page], :per_page => 5)
      end
    end
  end

  #Action to generate reports as pdf documents based on the filter criteria specified for the reports.
  def fetch_reports_download
    search_by_user_id = params[:user_id]
    search_by_treatment_type = params[:treatment_id]
    search_by_from_date = params[:from_date]
    search_by_to_date = params[:to_date]
    sql = "user_id = :user_id and DATE(created_at) between :from_date and :to_date"

    from_date = Date.parse(search_by_from_date)
    to_date = Date.parse(search_by_to_date)

    if !sql.blank?
      if search_by_treatment_type != "0"
        sql += " and comment_type_id = :comment_type_id"
        @user_patients = UserPatient.where(sql, {:user_id => search_by_user_id, :comment_type_id => search_by_treatment_type, :from_date => from_date, :to_date => to_date})
      else
        @user_patients = UserPatient.where(sql, {:user_id => search_by_user_id, :from_date => from_date, :to_date => to_date})
      end
    end

    respond_to do |format|
      format.html
      format.pdf do
        pdf = HmsPdfDocument.new(SessionsHelper::FOR_STAFF, @user_patients, view_context)
        send_data pdf.render, filename: "activity_summary_#{@user_patients.first.user.id}.pdf", type: "application/pdf"
      end
    end
  end

  private

  #private method used internally to populate required data such as users and comment types on the reports page.
  def pre_populate_reports
    if @users != nil
      @users_select_box = @users.map {|u| [u.first_name + " " + u.last_name, u.id]}
    end
    @comments_select_box = CommentType.all.map {|ct| [ct.comment_type_name, ct.id]}
    @comments_select_box.unshift(["All", 0]);
  end
end
