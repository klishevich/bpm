class AddAttachmentFileToReqPurchases < ActiveRecord::Migration
  def self.up
    change_table :req_purchases do |t|
      t.attachment :myfile
    end
  end

  def self.down
    remove_attachment :req_purchases, :myfile
  end
end
