Factory.define :user do |user|
  user.first_name "Ted"
  user.last_name "Mosby"
  user.email_id "ted@hms.com"
  user.password "abc123"
  user.user_type_id "1"
  user.password_confirmation "abc123"
end

Factory.define :patient do |patient|
  patient.first_name "Akshay"
  patient.last_name "Joshi"
  patient.email_id "akshay@patient.com"
  patient.phone "7547644"
  patient.date_of_birth "15-04-1985"
end

Factory.define :user_patient do |user_patient|
  user_patient.amount "100"
  user_patient.association :user
  user_patient.association :patient
  user_patient.comments "xyz xyz xyz xyz"
  user_patient.comment_type_id "1"
end
