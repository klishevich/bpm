class ReqPurchase < ActiveRecord::Base
  after_create :set_assignee
  has_many :assignments, as: :assignable
  validates :money, presence: true    
  validates :name, presence: true

  state_machine :initial => :new do
    before_transition :new => :wait_approval, :do => :create_assignments
    after_transition :wait_approval => any, :do => :close_assignments

    event :initiate do
      transition :new => :wait_approval
    end

    event :approve do
    	transition :wait_approval => :approved
    end

    event :disapprove do
    	transition :wait_approval => :disapproved
    end    

  end

  private

  def close_assignments
    close_assignment(self.user_id)
  end

  def create_assignments
    Rails.logger.info('!!!!! create_assignments') 
    chief_email = OrgStructure.get_chief(self.new_manager.email)
    new_user_id = User.where("email = ?", chief_email).first.id
    # Rails.logger.info('!!!!!' + self.user.id.to_s) 
    close_assignment(self.last_user_id)
    chief1_id = User.where("email = ?", "chief1@test.co").first.id
    new_assignment(chief1_id)  	
  end

  # standart operations, TODO move to parent class
  def set_assignee
    self.assignments.create(user_id: self.user_id, description: self.name)
  end

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

end
