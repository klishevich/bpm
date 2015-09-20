class ReqReassign < ActiveRecord::Base
  include ReqMain
  after_initialize :init
  after_create :set_assignee
  belongs_to :last_user, class_name: "User"
  belongs_to :client
  belongs_to :old_manager, class_name: "User"
  belongs_to :new_manager, class_name: "User"
  has_many :assignments, as: :assignable
  validates :new_manager_id, presence: true
  validates :old_manager_id, presence: true
  validates :client_id, presence: true
  validates :money, presence: true
  validates :name, presence: true  
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
    @disabled = Hash.new{|hash, key| hash[key] = Hash.new}
    # set false to edit field
    @disabled["new"]["new_manager"] = false
    @disabled["new"]["money"] = false
    @disabled["new"]["info"] = false
    @disabled["new"]["client"] = false
    @disabled["new"]["name"] = false
    @disabled["wait_approval"]["info"] = false
    @disabled["approved"]["info"] = false
    @disabled["disapproved"]["info"] = false
    @disabled["accepted_approved"]["info"] = false
    @disabled["accepted_disapproved"]["info"] = false  
  end

  def assign_to_manager
    close_assignment(self.last_user_id)
    new_assignment(self.new_manager_id)
  end

  def assign_to_chief
    Rails.logger.info('!!!!! assign to chief') 
    chief_email = OrgStructure.get_chief(self.new_manager.email)
    new_user_id = User.where("email = ?", chief_email).first.id
    # Rails.logger.info('!!!!!' + self.user.id.to_s) 
    close_assignment(self.last_user_id)
    new_assignment(new_user_id)
  end

  def assign_to_admin
    Rails.logger.info('!!!!! assign to admin') 
    new_user_id = User.where(email: 'admin@test.co').first.id
    close_assignment(self.last_user_id)
    new_assignment(new_user_id)    
  end

  def close_admin_assignment
    close_assignment(self.last_user_id)
  end

  def reassign_client
    Rails.logger.info('!!!!! reassign_client') 
    # Rails.logger.info(self.client.manager_id) 
    # Rails.logger.info(self.new_manager_id) 
    self.client.manager = self.new_manager
    self.client.save
  end  

  private  

  def check_need_approval
  	if self.money > 1000
  		self.check_approval_yes
  	else
  		self.check_approval_no
  	end
  end

end
