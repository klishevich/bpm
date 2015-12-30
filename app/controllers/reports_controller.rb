class ReportsController < ApplicationController

  def index
  end

  def sla
  	@req_types = req_types
  	@states = states
  	@assignments = Assignment.all
  	if params[:report_sla]
	  @state = params[:report_sla][:state] 
	  @user_id = params[:report_sla][:user_id]
	  @req_type = params[:report_sla][:req_type]
	  @date_begin = params[:report_sla][:date_begin]
	  @date_end = params[:report_sla][:date_end]
	end
	@assignments = @assignments.where(closed: true) if @state == 'closed'
	@assignments = @assignments.where(closed: false) if @state == 'opened'
	@assignments = @assignments.where(user_id: @user_id) if !@user_id.blank?
	@assignments = @assignments.where(assignable_type: @req_type) if !@req_type.blank?
	@assignments = @assignments.where("created_at >= ?", @date_begin) if !@date_begin.blank?	
	@assignments = @assignments.where("created_at <= ?", @date_end) if !@date_end.blank?	
  end

  private
  def req_types
  	['ReqReassign', 'ReqPurchase', 'ReqRolepurchase', 'ReqWorkgroup']
  end 

  def states
  	[['Закрытые','closed'],['Открытые', 'opened']]
  end

end
