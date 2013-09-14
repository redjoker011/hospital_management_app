class AddArchiveToUserPatients < ActiveRecord::Migration
  def change
    add_column :user_patients, :archive, :string
  end
end
