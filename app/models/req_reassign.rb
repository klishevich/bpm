class ReqReassign < ActiveRecord::Base
  after_initialize :init
  belongs_to :user
  belongs_to :client
  belongs_to :old_manager, class_name: "User"
  belongs_to :new_manager, class_name: "User"
  validates :new_manager_id, presence: true
  validates :old_manager_id, presence: true
  validates :client_id, presence: true
  validates :money, presence: true    
  state_machine :initial => :new do
    before_transition any => :check_approval, :do => :assign_to_admin
    after_transition any => :check_approval, :do => :check_need_approval
    before_transition :check_approval => :wait_approval, :do => :assign_to_manager
    before_transition any => [:approved, :disapproved], :do => :assign_to_chief
    before_transition any => [:accepted_approved, :accepted_disapproved], :do => :assign_to_admin
    after_transition any => :accepted_approved, :do => :reassign_client
    # before_transition any => any, :do => :set_new_user

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

  def assign_to_manager
    self.user_id = self.new_manager_id
    # if User.where(email: self.manager).exists?
    #   self.user = User.where(email: self.manager).first
    # end    
  end

  def assign_to_chief
    chief_email = OrgStructure.get_chief(self.new_manager.email)
    Rails.logger.info('!!!!!' + chief_email) 
    self.user = User.where("email = ?", chief_email).first
    Rails.logger.info('!!!!!' + self.user.id.to_s) 
  end

  def assign_to_admin
    self.user = User.where(email: 'admin@test.co').first
  end

  def is_disabled?(field)
    res = @hh[self.state][field]
    res = true if res.nil?
    res
  end

  def test
    @hh["new"]["name"]
  end

  private

  def check_need_approval
  	if self.money > 1000
  		self.check_approval_yes
  	else
  		self.check_approval_no
  	end
  end

  def reassign_client
    Rails.logger.info('!!!!! self.client.manager_id' + self.client.manager_id) 
    Rails.logger.info('!!!!! self.new_manager_id' + self.new_manager_id) 
    self.client.manager_id = self.new_manager_id
  end

end
