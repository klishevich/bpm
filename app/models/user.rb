class User < ActiveRecord::Base
  # has_many :req_reassigns, dependent: :destroy 
  has_many :clients, foreign_key: "manager_id", class_name: "Client", dependent: :destroy 
  has_many :old_req_reassigns, foreign_key: "old_manager_id", class_name: "User"
  has_many :new_req_reassigns, foreign_key: "new_manager_id", class_name: "User"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :name, presence: true
end
