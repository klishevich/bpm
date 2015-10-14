class InfWorkgroupMember < ActiveRecord::Base
  belongs_to :req_workgroup
  belongs_to :user
end