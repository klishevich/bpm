class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name
      t.string :code
      t.integer :level
      t.integer :parent_id, index: true
      t.integer :manager_id, index: true

      t.timestamps null: false
    end
    add_foreign_key :units, :units, column: :parent_id
    add_foreign_key :units, :users, column: :manager_id
  end
end
