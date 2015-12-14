class AddFieldsToAssignments < ActiveRecord::Migration
  def change
  	add_column :assignments, :close_date, :datetime
    add_column :assignments, :first_notify_date, :datetime
    add_column :assignments, :deadline_date, :datetime
    add_column :assignments, :second_notify_date, :datetime
  end
end
