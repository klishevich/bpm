class AddMyfileToReqPurchases < ActiveRecord::Migration
  def change
    add_column :req_purchases, :myfile, :string
  end
end
