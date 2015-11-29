class ReqRolepurchase < ActiveRecord::Base
  include ReqMain
  after_initialize :init
  after_create :set_assignee
  has_many :assignments, as: :assignable
  validates :money, presence: true    
  validates :name, presence: true
  belongs_to :last_user, class_name: "User"
  has_many :history, as: :historyable
  attr_accessor :assign_user_id
  validate :has_client_manager

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

  end

  def users_list
    User.joins("JOIN users_roles ur on ur.user_id = users.id 
                JOIN roles r on r.id = ur.role_id").where("r.code = ?", "client_manager")#.order(:name)
  end

  private

  def init
    self.state ||= 'new'
    # set false to show field for state in edit form    
    @disabled = Hash.new{|hash, key| hash[key] = Hash.new}
    @disabled["new"]["name"] = false
    @disabled["new"]["money"] = false 
    @disabled["wait_approval"]["name"] = false
    @disabled["wait_approval"]["money"] = false    
  end  

  def create_assignments
    Rails.logger.info('!!!!! create_assignments') 
    Rails.logger.info("!!!!! assign_user_id #{@assign_user_id}")
    Rails.logger.info("!!!!! last_user_id #{last_user_id}") 
    close_assignment(self.last_user_id)
    new_assignment(@assign_user_id) if !@assign_user_id.blank?	
  end

  def approve_assignment 
    Rails.logger.info('!!! approve_assignment')
    current_assignment = self.assignments.where(closed: false, user_id: self.last_user_id).first
    current_assignment.update_attributes(closed: true, result: 'approved') if !current_assignment.nil?
    self.update_attributes(state: 'finish_approved')
  end

  def disapprove_assignment 
    Rails.logger.info('!!! disapprove_assignment')
    current_assignment = self.assignments.where(closed: false, user_id: self.last_user_id).first
    current_assignment.update_attributes(closed: true, result: 'disapproved') if !current_assignment.nil?
    self.update_attributes(state: 'finish_disapproved')   
  end

  #validations

  def has_client_manager
    # Rails.logger.info('!!!!! one_group_leader')
    # Rails.logger.info(self.inf_workgroup_members.where(main: true).count)
    if self.state == 'wait_approval' and @assign_user_id.blank?
      errors.add(:assign_user_id, :validate_has_client_manager)
    end
  end 

end
