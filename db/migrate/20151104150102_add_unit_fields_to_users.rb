class AddUnitFieldsToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :unit, index: true, foreign_key: true
    add_column :users, :code, :string
    add_column :users, :unit_code, :string
    add_column :users, :deleted, :boolean, default: false

  end
end
