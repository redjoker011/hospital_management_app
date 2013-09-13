class ChangeDataTypeForUserPatient < ActiveRecord::Migration

  def self.up
    change_table :user_patients do |t|
      t.change :amount, :decimal, :precision => 4, :scale => 20
    end
  end

  def self.down
    change_table :user_patients do |t|
      t.change :amount, :integer
    end
  end
end
