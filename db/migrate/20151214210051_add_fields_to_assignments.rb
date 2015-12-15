class AddFieldsToAssignments < ActiveRecord::Migration
  def change
  	add_column :assignments, :close_date, :datetime
    add_column :assignments, :deadline_date, :datetime
    add_column :assignments, :notify_before_date, :datetime
    add_column :assignments, :notify_after_date, :datetime
  end
end
