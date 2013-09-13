class Patient < ActiveRecord::Base
  attr_accessible :date_of_birth, :email_id, :first_name, :last_name, :phone

  validates :date_of_birth, :presence => true
  validates :email_id, :presence => true, :format => {:with => SessionsHelper::EMAIL_REGEX}
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true

  has_many :user_patients
  has_many :users, :through => :user_patients

  def date_of_birth_string
    if !date_of_birth.blank? && date_of_birth != nil
      date_of_birth.strftime("%d-%m-%Y")
    end
  end

  def created_at_string
    if !created_at.blank? && created_at != nil
      created_at.strftime("%d-%m-%Y")
    end
  end

end
