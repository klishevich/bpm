class CreateReqPurchases < ActiveRecord::Migration
  def change
    create_table :req_purchases do |t|
      t.string :state, :default => 'new'
      t.integer :last_user_id, index: true
      t.string :name
      t.timestamps null: false

      t.integer :money
    end
  end
end
