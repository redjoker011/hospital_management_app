FactoryGirl.define do
  factory :user do
    first_name "Ted"
    last_name "Mosby"
    email_id "ted@hms.com"
    password "abc123"
    user_type_id "1"
    password_confirmation "abc123"
  end
end

FactoryGirl.define do
  factory :patient do
    first_name "Akshay"
    last_name "Joshi"
    email_id "akshay@patient.com"
    phone "7547644"
    date_of_birth "15-04-1985"
  end
end

FactoryGirl.define do 
  factory :user_patient do
    amount "100"
    association :user
    association :patient
    comments "xyz xyz xyz xyz"
    comment_type_id "1"
  end
end
