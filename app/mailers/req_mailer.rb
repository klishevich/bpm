class ReqMailer < ActionMailer::Base
  default from: "no-reply@bpm.j123.ru"

  def new_assignment_notification(assignment)
    @assignment = assignment
    Rails.logger.debug 'test_email'
    mail to: "m.klishevich@yandex.ru, #{@assignment.user.email}", subject: t(:new_req)
  end

  # def test_email1
  # 	Rails.logger.debug 'test_email'
  # 	mail(:to => 'm.klishevich@yandex.ru', :subject => "testing rails", body: "lasfkasf")
  # end

end
