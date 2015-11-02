class Unit < ActiveRecord::Base
  belongs_to :manager, class_name: "User"
  belongs_to :parent, class_name: "Unit"
  has_many :children, foreign_key: "parent_id", class_name: "Unit"

end
