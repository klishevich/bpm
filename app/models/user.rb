class User < ActiveRecord::Base
  # has_many :req_reassigns, dependent: :destroy 
  has_many :clients, foreign_key: "manager_id", class_name: "Client", dependent: :destroy 
  has_many :old_req_reassigns, foreign_key: "old_manager_id", class_name: "User"
  has_many :new_req_reassigns, foreign_key: "new_manager_id", class_name: "User"
  has_many :users_roles, dependent: :destroy
  accepts_nested_attributes_for :users_roles, allow_destroy: true,
    reject_if: proc { |attributes| attributes['role_id'].blank? }
  has_many :roles, through: :users_roles
  belongs_to :unit
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :name, presence: true
end
