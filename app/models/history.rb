class History < ActiveRecord::Base
  belongs_to :historyable, polymorphic: true
  belongs_to :user
end
