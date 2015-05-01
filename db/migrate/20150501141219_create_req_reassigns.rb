class CreateReqReassigns < ActiveRecord::Migration
  def change
    create_table :req_reassigns do |t|
      t.string :state, :default => 'new'
      t.string :role
      t.string :name
      t.string :manager
      t.string :inn
      t.integer :money

      t.timestamps null: false
    end
  end
end
