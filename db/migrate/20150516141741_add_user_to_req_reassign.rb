class AddUserToReqReassign < ActiveRecord::Migration
  def change
    add_reference :req_reassigns, :user, index: true, foreign_key: true
  end
end
