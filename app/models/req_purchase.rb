class ReqPurchase < ActiveRecord::Base
  after_initialize :init
  after_create :set_assignee
  has_many :assignments, as: :assignable
  validates :money, presence: true    
  validates :name, presence: true
  belongs_to :last_user, class_name: "User"
  has_many :history, as: :historyable

  state_machine :initial => :new do
    before_transition :new => :wait_approval, :do => :create_assignments
    after_transition :wait_approval => :approved, :do => :approve_assignment
    after_transition :wait_approval => :disapproved, :do => :disapprove_assignment
    after_transition any => any, :do => :write_history

    event :initiate do
      transition :new => :wait_approval
    end

    event :approve do
    	transition :wait_approval => :approved
    end

    event :disapprove do
    	transition :wait_approval => :disapproved
    end    

    state :finish_approved
    state :finish_disapproved

    # event :finish_approve do
    #   transition all => :finish_approved
    # end

    # event :finish_disapprove do
    #   transition all => :finish_disapproved
    # end

  end

  # --------- standart public methods ---------

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

  private

  def init
    self.last_user_id ||= User.where("email = ?", "admin@test.co").first.id
    self.state ||= 'new'
    # set false to show field for state in edit form    
    @disabled = Hash.new{|hash, key| hash[key] = Hash.new}
    @disabled["new"]["name"] = false
    @disabled["new"]["money"] = false    
    # @disabled["wait_approval"]["money"] = false    
  end  

  # def close_assignments
  #   close_assignment(self.last_user_id)
  # end

  def create_assignments
    Rails.logger.info('!!!!! create_assignments')  
    close_assignment(self.last_user_id)
    chief1_id = User.where("email = ?", "chief1@test.co").first.id
    new_assignment(chief1_id) 
    chief2_id = User.where("email = ?", "chief2@test.co").first.id
    new_assignment(chief2_id)      	
  end

  def approve_assignment 
    Rails.logger.info('!!! approve_assignment')
    current_assignment = self.assignments.where(closed: false, user_id: self.last_user_id).first
    current_assignment.update_attributes(closed: true, result: 'approved') if !current_assignment.nil?
    Rails.logger.info(has_opened_assignments)    
    if has_opened_assignments
      Rails.logger.info("!!! has opened assignments")    
      self.update_attributes(state: 'wait_approval')
    else
      Rails.logger.info("!!! no opened assignments")
      finish_approvement
    end
  end

  def disapprove_assignment 
    Rails.logger.info('!!! disapprove_assignment')
    current_assignment = self.assignments.where(closed: false, user_id: self.last_user_id).first
    current_assignment.update_attributes(closed: true, result: 'disapproved') if !current_assignment.nil?
    if has_opened_assignments
      self.update_attributes(state: 'wait_approval')
    else
      finish_approvement
    end    
  end

  def has_opened_assignments
    Rails.logger.info('!!! has_opened_assignments') 
    assignments = self.assignments.where(closed: false)
    Rails.logger.info(assignments.count) 
    if assignments.count > 0
      true
    else
      false
    end
  end   

  def finish_approvement
    Rails.logger.info('!!! finish_approvement') 
    if self.assignments.where(result: 'disapproved').count == 0
      Rails.logger.info('!!! finish_approved')       
      self.update_attributes(state: 'finish_approved')
    else
      Rails.logger.info('!!! finish_disapproved')       
      self.update_attributes(state: 'finish_disapproved')
    end
  end 

  # ------ standart operations, TODO move to parent class ---------
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
      self.assignments.create(user_id: user_id, description: self.name)  
    end         
  end

  def write_history
    Rails.logger.info('!!!!! write_history') 
    text = self.last_user.name + I18n.t(:changed_state_to) + self.state
    self.history.create(state: self.state, user_id: self.last_user_id, description: text, 
      new_values: 'TO DO')
  end

end
