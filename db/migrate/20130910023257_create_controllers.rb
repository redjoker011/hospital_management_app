class CreateControllers < ActiveRecord::Migration
  def change
    create_table :controllers do |t|
      t.string :Sessions
      t.string :new

      t.timestamps
    end
  end
end
