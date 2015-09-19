class CreateReqPurchases < ActiveRecord::Migration
  def change
    create_table :req_purchases do |t|
      t.string :state, :default => 'new'
      t.integer :last_user_id, index: true
      t.timestamps null: false

      t.string :name
      t.integer :money
    end
  end
end
