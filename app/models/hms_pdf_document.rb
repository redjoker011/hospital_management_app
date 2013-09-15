#PDF document template especially customized for this application. Uses prawn to generate pdf documents.

require 'prawn'
class HmsPdfDocument < Prawn::Document
  def initialize(purpose, user_patients, viewObj)
    super()
    @purpose = purpose
    @user_patients = user_patients
    @view = viewObj
    include_logo
    if(@purpose == SessionsHelper::FOR_PATIENT)
      include_patient_data
      include_bill_summary
    else
      include_employee_data
      include_performance_summary
    end
  end

  def include_logo
    logo_path =  "#{Rails.root}/app/assets/images/hms.jpg"
    image logo_path, :width => 241, :height => 75
  end

  def include_patient_data
    draw_text "Patient Id: #{@user_patients.first.patient.id}", :at => [270, 700], size: 15
    draw_text "Patient Name: #{@user_patients.first.patient.first_name + " "+ @user_patients.first.patient.last_name}", :at => [270, 677], size: 15
    draw_text "Contact #: #{@user_patients.first.patient.phone}", :at => [270, 656], size: 15
    draw_text "Receipt", :at => [220, 590], size: 16
  end

  def include_employee_data
    draw_text "Employee Id: #{@user_patients.first.user.id}", :at => [270, 700], size: 15
    draw_text "Employee Name: #{@user_patients.first.user.first_name + " "+ @user_patients.first.user.last_name}", :at => [270, 677], size: 15
    draw_text "Designation: #{@user_patients.first.user.user_type.user_type_name}", :at => [270, 656], size: 15
    draw_text "Performance details", :at => [220, 590], size: 16
  end

  def include_bill_summary
    move_down 70
    total_bill = 0

    table([["Staff/Doctor","Created Date","Purpose", "Description", "Bill Amount"]],
          :column_widths => {0 => 70, 1 => 75, 2 => 77, 3 => 250, 4 => 68}, :row_colors => ["d5d5d5"])
    @user_patients.each do|up|
      total_bill += up.amount
      table([["#{up.user.first_name + " " + up.user.last_name}", "#{up.created_at_string}", "#{up.comment_type.comment_type_name}", "#{up.comments}", "#{up.amount}"]],
            :column_widths => {0 => 70, 1 => 75, 2 => 77, 3 => 250, 4 => 68}, :row_colors => ["ffffff"])
    end

    move_down 20

    text "Total Bill: #{total_bill} (including tax)"
  end

  def include_performance_summary
    move_down 70

    table([["Purpose", "Description", "Activity Date", "Bill Amount"]],
          :column_widths => {0 => 80, 1 => 300, 2 => 80, 3 => 80}, :row_colors => ["d5d5d5"])
    @user_patients.each do|up|
      table([["#{up.comment_type.comment_type_name}", "#{up.comments}", "#{up.created_at_string}", "#{up.amount}"]],
            :column_widths => {0 => 80, 1 => 300, 2 => 80, 3 => 80}, :row_colors => ["ffffff"])
    end
  end

end