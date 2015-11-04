class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name
      t.string :code
      t.string :parent_code
      t.string :manager_code
      t.integer :level
      t.integer :parent_id, index: true
      t.integer :manager_id, index: true
      t.boolean :deleted, default: false

      t.timestamps null: false
    end
    add_foreign_key :units, :units, column: :parent_id
    add_foreign_key :units, :users, column: :manager_id
  end
end
