class CreateUsersRoles < ActiveRecord::Migration
  def change
    create_table :users_roles, :id => false do |t|
      t.references :user, index: true, foreign_key: true
      t.references :role, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
