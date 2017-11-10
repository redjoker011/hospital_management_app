class CreateControllers < ActiveRecord::Migration[5.0]
  def change
    create_table :controllers do |t|
      t.string :Sessions
      t.string :new

      t.timestamps
    end
  end
end
