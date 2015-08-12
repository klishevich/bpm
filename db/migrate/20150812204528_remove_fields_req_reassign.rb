class RemoveFieldsReqReassign < ActiveRecord::Migration
	change_table :req_reassigns do |t|
	  t.remove :name, :manager, :inn, :old_manager, :string
	end
end
