module ReqMain
  def is_assigned?(user_id)
    self.assignments.where(closed: false, user_id: user_id).first.nil? ? false : true
  end

  def opened_assignment_users
    assignments = self.assignments.where(closed: false)
    Rails.logger.info('!!!!! opened_assignment_users') 
    Rails.logger.info(assignments.count) 
    if assignments.count > 0
      assignments.map {|x| x.user.name }.join(', ')
    else
      ""
    end
  end  

  def is_disabled?(field)
    res = @disabled[self.state][field]
    res = true if res.nil?
    res
  end  

  def set_last_user(user)
    self.last_user_id = user.id
  end

  private

  def set_assignee 
    # user_id ||= User.where("email = ?", "admin@test.co").first.id
    self.assignments.create(user_id: self.last_user_id, description: self.name)
  end

  def close_assignment(user_id)
    Rails.logger.info('!!!!! close_assignment') 
    Rails.logger.info(user_id)
    current_assignment = self.assignments.where(closed: false, user_id: user_id).first
    current_assignment.update_attributes(closed: true, close_date: Time.now) if !current_assignment.nil?
  end

  def new_assignment(user_id)
    Rails.logger.info('!!!!! new_assignment') 
    opened_assignments = self.assignments.where(closed: false, user_id: user_id).count
    if opened_assignments == 0
      new_assignment = self.assignments.create(user_id: user_id, description: self.name, 
        deadline_date: sla_deadline_date, notify_before_date: sla_notify_before_date,
        notify_after_date: sla_notify_after_date)  
    end         
  end

  def write_history
    Rails.logger.info('!!!!! write_history') 
    text = self.last_user.name + I18n.t(:changed_state_to) + self.state
    self.history.create(state: self.state, user_id: self.last_user_id, description: text, 
      new_values: 'TO DO')
  end

  def sla_deadline_date
    Rails.logger.info('!!!!! sla_deadline_date before if, days, state') 
    if !@sla.nil?
      days = @sla[self.state]["deadline"]
      Rails.logger.info("#{days}, #{self.state}")
      res = days.blank? ? nil : Time.now + (days*24*60*60)
    end
    res
  end 

  def sla_notify_before_date
    Rails.logger.info('!!!!! sla_notify_before_date before if, hours') 
    if !@sla.nil? && sla_deadline_date
      hours = @sla[self.state]["notify_before"]
      Rails.logger.info(hours)
      res = hours.blank? ? nil : sla_deadline_date - (hours*60*60)
    end
    res
  end

  def sla_notify_after_date
    Rails.logger.info('!!!!! sla_notify_after_date before if, hours') 
    if !@sla.nil? && sla_deadline_date
      hours = @sla[self.state]["notify_after"]
      Rails.logger.info(hours)
      res = hours.blank? ? nil : sla_deadline_date + (hours*60*60)
    end
    res
  end 

end