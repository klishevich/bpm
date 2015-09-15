class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :historyable, polymorphic: true, index: true
      t.string :state
      t.references :user, index: true, foreign_key: true
      t.text :description
      t.text :new_values

      t.timestamps null: false
    end
  end
end
