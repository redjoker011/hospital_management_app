require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  #validations for the attributes of this entity.
  validates :password, :presence => true, :confirmation => true, :length => {:within => 6..12}, :on => :create
  validates :email_id, :presence => true, :format => {:with => SessionsHelper::EMAIL_REGEX}
  validates :first_name, :presence => true
  validates :last_name, :presence => true


  #establishing one-to-one relation with user_type (A user can be of only one role)
  belongs_to :user_type, :foreign_key => :user_type_id

  #before save filter to encrypt password.
  before_save :encrypt_password

  #User can treat many patients. similarly, patients can get treatment from many Users so many to many relation between Users and Patients
  # is connected through intersection table user_patients.
  has_many :user_patients
  has_many :patients, :through => :user_patients

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  #Utility method to authenticate user.
  def self.authenticate_with_salt(user_id)
    return nil if user_id == nil
    user = User.find(user_id[0])
    (user && user.salt == user_id[1]) ? user : nil
  end

  def self.authenticate(email, pwd)
    user = User.find_by_email_id(email)
    if(user && user.has_password?(pwd))
      return user
    else
      return nil
    end
  end

  private
  #private method to encrypt password using SHA2 Digest.
  def encrypt_password
    if(password.blank?)
      return
    else
      self.salt = make_salt(password) unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end
  end

  def encrypt(pwd)
    secure_hash("#{salt}#{pwd}")
  end

  def secure_hash(str)
    Digest::SHA2.hexdigest(str)
  end

  def make_salt(str)
    secure_hash "#{Time.now.utc}#{str}"
  end
end
