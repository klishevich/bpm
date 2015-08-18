class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :assignable, polymorphic: true, index: true
      t.string :description
      t.boolean :closed, default: false
      t.timestamps null: false
    end
  end
end
