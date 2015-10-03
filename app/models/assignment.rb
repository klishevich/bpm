class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignable, polymorphic: true
  after_create :send_new_assignment_notification
  # before_save :send_new_assignment_notification

  private

  def send_new_assignment_notification
    ReqMailer.new_assignment_notification(self).deliver_now
  end
end
