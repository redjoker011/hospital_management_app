class ChangeDataTypeForUserPatient < ActiveRecord::Migration[5.0]

  def self.up
    change_table :user_patients do |t|
      t.change :amount, :decimal
    end
  end

  def self.down
    change_table :user_patients do |t|
      t.change :amount, :integer
    end
  end
end
