class ReqPurchase < ActiveRecord::Base
  include ReqMain
  after_initialize :init
  after_create :set_assignee
  has_many :assignments, as: :assignable
  validates :money, presence: true    
  validates :name, presence: true
  belongs_to :last_user, class_name: "User"
  has_many :history, as: :historyable
  mount_uploader :myfile, MyfileUploader
  # validate :test_val

  # def test_val
  #   errors.add(:myfile, :blank)
  # end 

  state_machine :initial => :new do
    after_transition :new => :wait_approval, :do => :create_assignments
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

  end

  private

  def init
    self.state ||= 'new'
    
    # ----- SET EDITABLE FIELDS FOR STATE IN EDIT VIEW (editable if false) -----
    @disabled = Hash.new{|hash, key| hash[key] = Hash.new}
    @disabled["new"]["name"] = false
    @disabled["new"]["money"] = false    
    # @disabled["wait_approval"]["money"] = false 

    # ------ SET SLA FOR PROCESS -------
    # для SLA необходимо использовать after_transition, чтобы в настройке указывался целевой статус
    @sla = Hash.new{|hash, key| hash[key] = Hash.new}
    # days
    @sla["wait_approval"]["deadline"] = 3
    #hours
    @sla["wait_approval"]["notify_before"] = 12
    @sla["wait_approval"]["notify_after"] = 24

  end  

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

end
