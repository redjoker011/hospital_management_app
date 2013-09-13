class CreateUserPatients < ActiveRecord::Migration
  def change
    create_table :user_patients do |t|
      t.integer :user_id
      t.integer :patient_id
      t.text :comments
      t.integer :amount
      t.integer :comment_type_id

      t.timestamps
    end
  end
end
