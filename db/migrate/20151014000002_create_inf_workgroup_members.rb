class CreateInfWorkgroupMembers < ActiveRecord::Migration
  def change
    create_table :inf_workgroup_members do |t|
      t.references :req_workgroup, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :main, default: false
      t.string :comment
      t.timestamps null: false
    end
  end 
end
