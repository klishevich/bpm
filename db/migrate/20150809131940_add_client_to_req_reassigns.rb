class AddClientToReqReassigns < ActiveRecord::Migration
  def change
    add_reference :req_reassigns, :client, index: true, foreign_key: true
    add_index :clients, :manager_id
  end
end
