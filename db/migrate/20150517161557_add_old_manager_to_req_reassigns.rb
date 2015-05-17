class AddOldManagerToReqReassigns < ActiveRecord::Migration
  def change
    add_column :req_reassigns, :old_manager, :string
    add_column :req_reassigns, :string, :string
  end
end
