class ReqReassignsController < ApplicationController
  # before_action :authenticate_user!
  before_filter :not_assigned, only: [:edit, :update]

  def index
  	@reqs = ReqReassign.where('state not in (?)', 'closed').order('id desc')
  end

  def new
    @req = ReqReassign.new
    # @req.old_manager_id = current_user.id
  end

  def create
    params[:req_reassign][:last_user_id] = current_user.id
    params[:req_reassign][:old_manager_id] = current_user.id

    @req = ReqReassign.new(req_params)
    if @req.save
      redirect_to @req
    else
      render 'new'
    end  
  end

  def show
    @req = ReqReassign.find(params[:id])
    @history = @req.history
    respond_to do |format|
      format.html       
    end  	
  end

  def edit
    @req=ReqReassign.find(params[:id])
  end

  def update
    # params[:req_reassign][:last_user_id] = current_user.id
    @req = ReqReassign.find(params[:id])
    @req.set_last_user(current_user)
    action = params[:commit]
    Rails.logger.info('!!!!!'+action) if action
    if action == 'save'
      # @req = ReqReassign.find(params[:id])
      if @req.update_attributes(req_params)
        flash[:success] = t(:req_updated_successfuly)
        redirect_to @req
      else
        render 'edit'
      end
    else
      # @req = ReqReassign.find(params[:id])
      @req.assign_attributes(req_params)
      if @req.send(action)
        flash[:success] = t(:req_updated_successfuly)
        redirect_to @req
      else
        render 'edit'
      end      
    end
  end  

  private

  def req_params
    params.require(:req_reassign).permit(:old_manager_id, :money, :new_manager_id, :info, :client_id, :last_user_id, :name)
  end     

  def not_assigned
    req = ReqReassign.find(params[:id])
    unless req.is_assigned?(current_user)
      redirect_to root_path
    end   
  end

end
