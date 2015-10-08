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
    current_assignment.update_attributes(closed: true) if !current_assignment.nil?
  end

  def new_assignment(user_id)
    Rails.logger.info('!!!!! new_assignment') 
    opened_assignments = self.assignments.where(closed: false, user_id: user_id).count
    if opened_assignments == 0
      new_assignment = self.assignments.create(user_id: user_id, description: self.name)  
    end         
  end

  def write_history
    Rails.logger.info('!!!!! write_history') 
    text = self.last_user.name + I18n.t(:changed_state_to) + self.state
    self.history.create(state: self.state, user_id: self.last_user_id, description: text, 
      new_values: 'TO DO')
  end

end