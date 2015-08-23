class CreateReqPurchases < ActiveRecord::Migration
  def change
    create_table :req_purchases do |t|
      t.string :state, :default => 'new'
      t.string :name
      t.integer :money
      t.integer :last_user_id

      t.timestamps null: false
    end
  end
end
