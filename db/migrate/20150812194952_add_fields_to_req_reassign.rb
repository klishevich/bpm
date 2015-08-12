class AddFieldsToReqReassign < ActiveRecord::Migration
  def change
  	add_column :req_reassigns, :old_manager_id, :integer
  	add_column :req_reassigns, :new_manager_id, :integer
  	add_index :req_reassigns, :old_manager_id
  	add_index :req_reassigns, :new_manager_id
  end
end
