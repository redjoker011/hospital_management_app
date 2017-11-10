class AddArchiveToUserPatients < ActiveRecord::Migration[5.0]
  def change
    add_column :user_patients, :archive, :string
  end
end
