class AssignmentsController < ApplicationController
  before_action :authenticate_user!
  def index
   	@assignments = Assignment.where(user_id: current_user.id).order('id desc')
  end
end
