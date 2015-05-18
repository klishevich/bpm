class AddInfoToReqReassigns < ActiveRecord::Migration
  def change
    add_column :req_reassigns, :info, :text
  end
end
