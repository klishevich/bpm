class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :inn
      t.references :manager, references: :users

      t.timestamps null: false
    end
  end
end
