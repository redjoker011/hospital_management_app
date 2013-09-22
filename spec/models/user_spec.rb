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

  it ":password and password_confirmation must match" do
    test_user = User.new(@user_attributes.merge({:password => "abc1234", :password_confirmation => "xyz1234"}))
    test_user.should_not be_valid
  end

  it ": must accept passwords of length 6 to 12" do
    test_user = User.new(@user_attributes.merge({:password => "abc", :password_confirmation => "abc"}))
    test_user.should_not be_valid
  end


end