class CreateReqReassigns < ActiveRecord::Migration
  def change
    create_table :req_reassigns do |t|
      t.string :state, :default => 'new'
      t.integer :last_user_id, index: true
      t.string :name
      t.timestamps null: false
      
      t.string :role
      t.integer :money
      t.integer :old_manager_id, index: true
      t.integer :new_manager_id, index: true
      t.references :client, index: true, foreign_key: true
      t.text :info
      
    end
  end
end