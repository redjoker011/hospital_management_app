require 'spec_helper'

describe User do
  before(:each) do
    @user_attributes = {
        :first_name => "Jason",
        :last_name => "Segal",
        :email_id => "jason@hms.com",
        :password => "abc123",
        :password_confirmation => "abc123",
        :user_type_id => "1"
    }
  end

  it ": should create new user object" do
    User.create!(@user_attributes)
  end

  it ": first name is required" do
    test_user = User.new(@user_attributes.merge({:first_name => ""}))
    test_user.should_not be_valid
  end

  it ": last name is required" do
    test_user = User.new(@user_attributes.merge({:last_name => ""}))
    test_user.should_not be_valid
  end

  it ": should require email_address" do
    test_user = User.new(@user_attributes.merge({:email_id => ""}))
    test_user.should_not be_valid
  end

  it ": email_id should be of correct format" do
    test_user = User.new(@user_attributes.merge({:email_id => "ppp"}))
    test_user.should_not be_valid
  end

  it ": password should not be blank" do
    test_user = User.new(@user_attributes.merge({:password => "", :password_confirmation => ""}))
    test_user.should_not be_valid
  end

  it ": password and password_confirmation must match" do
    test_user = User.new(@user_attributes.merge({:password => "abc1234", :password_confirmation => "xyz1234"}))
    test_user.should_not be_valid
  end

  it ": must accept passwords of length 6 to 12" do
    test_user = User.new(@user_attributes.merge({:password => "abc", :password_confirmation => "abc"}))
    test_user.should_not be_valid
  end

  describe "Authentication" do
    before(:each) do
      @user = User.create!(@user_attributes)
    end

    it ": must authenticate user by email_id and password" do
      User.authenticate("jason@hms.com", "abc123").should == @user
    end

    it ": must reject if password or email_id is wrong" do
      User.authenticate("jason@hms.com", "xyz123").should be_nil
    end
  end

  describe "Test associations" do
    before(:each) do
      @user = User.create!(@user_attributes)
      @user_patient1 = Factory(:user_patient, :comments => "abc abc abc", :user => @user)
      @user_patient2 = Factory(:user_patient, :comments => "test test test", :user => @user)
    end

    it ": must have associated user_patient objects" do
      @user.user_patients.size.should == 2
    end

    it ": must describe the type of user" do
     @user.user_type.user_type_name.should eql "ADMIN"
    end
  end
end