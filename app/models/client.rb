class Client < ActiveRecord::Base
  belongs_to :manager, class_name: "User"
end
