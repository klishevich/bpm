class AssignmentsController < ApplicationController
  def index
   	@assignments = Assignment.where(user_id: current_user.id).order('id desc')
  end
end
