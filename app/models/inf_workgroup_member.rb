class InfWorkgroupMember < ActiveRecord::Base
  belongs_to :req_workgroup
  belongs_to :user

  validates :req_workgroup, presence: true
  validates :user, presence: true
end