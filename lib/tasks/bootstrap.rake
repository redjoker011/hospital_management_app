
#First time setup utility, populates required static data in the database such as user_types, comment_types.
#Creates default user with admin privileges. (username: admin@hms.com, password: abc123)
namespace :bootstrap do
  desc "populate user types"
  task :user_types_data => :environment do
    UserType.create(:user_type_name => "ADMIN")
    UserType.create(:user_type_name => "DOCTOR")
    UserType.create(:user_type_name => "STAFF")
  end

  desc "populate comments type"
  task :comment_types_data => :environment do
    CommentType.create(:comment_type_name => "SURGERY")
    CommentType.create(:comment_type_name => "PRESCRIPTION")
    CommentType.create(:comment_type_name => "MEDICINES")
  end

  desc "Create the default user admin"
  task :default_user => :environment do
    ut = UserType.find_by_user_type_name("ADMIN")
    User.create( :first_name => "Admin", :last_name => "Admin", :password => "abc123",
                 :password_confirmation => "abc123", :email_id => "admin@hms.com", :user_type_id => ut.id)
  end

  desc "Run all bootstrapping tasks for hospital management system"
  task :all => [:user_types_data, :comment_types_data, :default_user]
end
