class ReqReassign < ActiveRecord::Base
  after_initialize :init
  after_create :set_assignee
  belongs_to :user
  belongs_to :client
  belongs_to :old_manager, class_name: "User"
  belongs_to :new_manager, class_name: "User"
  has_many :assignments, as: :assignable
  validates :new_manager_id, presence: true
  validates :old_manager_id, presence: true
  validates :client_id, presence: true
  validates :money, presence: true    
  has_many :history, as: :historyable

  state_machine :initial => :new do
    after_transition any => :check_approval, :do => :check_need_approval
    before_transition :check_approval => :wait_approval, :do => :assign_to_manager
    before_transition any => [:approved, :disapproved], :do => :assign_to_chief
    before_transition any => [:accepted_approved, :accepted_disapproved], :do => :assign_to_admin
    after_transition any => :accepted_approved, :do => :reassign_client
    after_transition any => :closed, :do => :close_admin_assignment
    # before_transition any => any, :do => :set_new_user
    after_transition any => any - :check_approval, :do => :write_history


    event :initiate do
      transition :new => :check_approval
    end

    event :check_approval_no do
      transition :check_approval => :dont_need_approval
    end

    event :check_approval_yes do
      transition :check_approval => :wait_approval
    end

    event :approve do
      transition :wait_approval => :approved
    end

    event :disapprove do
    	transition :wait_approval => :disapproved
    end

    event :accept do
    	transition :approved => :accepted_approved, :disapproved => :accepted_disapproved
    end

    event :repeat do
    	transition [:approved, :disapproved] => :wait_approval
    end

    event :close do
      transition [:accepted_approved, :accepted_disapproved] => :closed
    end

  end

  def init
    self.role ||= 'manager'
    self.state ||= 'new' 
    @hh = Hash.new{|hash, key| hash[key] = Hash.new}
    # set false to show field
    @hh["new"]["new_manager"] = false
    @hh["new"]["money"] = false
    @hh["new"]["info"] = false
    @hh["new"]["client"] = false
    @hh["wait_approval"]["info"] = false
    @hh["approved"]["info"] = false
    @hh["disapproved"]["info"] = false
    @hh["accepted_approved"]["info"] = false
    @hh["accepted_disapproved"]["info"] = false  
  end

  def set_assignee
    self.assignments.create(user_id: self.user_id, description: self.info)
  end

  def assign_to_manager
    # self.user_id = self.new_manager_id
    close_assignment(self.user_id)
    new_assignment(self.new_manager_id)
  end

  def assign_to_chief
    Rails.logger.info('!!!!! assign to chief') 
    chief_email = OrgStructure.get_chief(self.new_manager.email)
    new_user_id = User.where("email = ?", chief_email).first.id
    # Rails.logger.info('!!!!!' + self.user.id.to_s) 
    close_assignment(self.user_id)
    new_assignment(new_user_id)
  end

  def assign_to_admin
    Rails.logger.info('!!!!! assign to admin') 
    new_user_id = User.where(email: 'admin@test.co').first.id
    close_assignment(self.user_id)
    new_assignment(new_user_id)    
  end

  def close_admin_assignment
    close_assignment(self.user_id)
  end

  def is_disabled?(field)
    res = @hh[self.state][field]
    res = true if res.nil?
    res
  end

  def test
    @hh["new"]["name"]
  end

  def reassign_client
    Rails.logger.info('!!!!! reassign_client') 
    # Rails.logger.info(self.client.manager_id) 
    # Rails.logger.info(self.new_manager_id) 
    self.client.manager = self.new_manager
    self.client.save
  end  

  def is_assigned?(user_id)
    self.assignments.where(closed: false, user_id: user_id).first.nil? ? false : true
  end

  # def opened_assignments
  #   self.assignments.where(closed: false)
  # end

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

  private  

  def close_assignment(user_id)
    Rails.logger.info('!!!!! close assignment') 
    Rails.logger.info(user_id)
    current_assignment = self.assignments.where(closed: false, user_id: user_id).first
    current_assignment.update_attributes(closed: true) if !current_assignment.nil?
  end

  def new_assignment(user_id)
    Rails.logger.info('!!!!! open assignment') 
    opened_assignments = self.assignments.where(closed: false, user_id: user_id).count
    if opened_assignments == 0
      self.assignments.create(user_id: user_id, description: self.info)  
    end         
  end

  # def assign_to(old_user_id = nil, new_user_id = nil)
  #   opened_assignments = self.assignments.where(closed: false).count
  #   if opened_assignments == 1
  #     current_assignment = self.assignments.where(closed: false).first
  #     current_assignment.update_attributes(closed: true)
  #     self.assignments.create(user_id: new_user_id, description: self.info)           
  #   else
  #     lkjljk
  #   end
  # end

  def write_history
    Rails.logger.info('!!!!! write_history') 
    text = self.user.name + I18n.t(:changed_state_to) + self.state
    self.history.create(state: self.state, user_id: self.user_id, description: text, 
      new_values: 'TO DO')
  end  

  def check_need_approval
  	if self.money > 1000
  		self.check_approval_yes
  	else
  		self.check_approval_no
  	end
  end

end
