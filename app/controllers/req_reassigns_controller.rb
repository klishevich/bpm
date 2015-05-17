class ReqReassignsController < ApplicationController
  before_action :authenticate_user!

  def index
  	@reqs = ReqReassign.where('state not in (?)', 'closed').order('id desc')
  end

  def new
    @req = current_user.req_reassigns.build
  end

  def create
    params[:req_reassign][:old_manager] = current_user.email
    @req = current_user.req_reassigns.build(req_params)
    if @req.save
      # flash[:success] = t(:ok)
      redirect_to @req
    else
      render 'new'
    end  
  end

  def show
    @req = ReqReassign.find(params[:id])
    respond_to do |format|
      format.html       
    end  	
  end

  def edit
    @req=ReqReassign.find(params[:id])
  end

  def update
    action = params[:commit]
    Rails.logger.info('!!!!!'+action) if action
    if action == 'save'
      @req = ReqReassign.find(params[:id])
      if @req.update_attributes(req_params)
        flash[:success] = 'req_updated_successfuly'
        redirect_to @req
      else
        render 'edit'
      end
    else
      @req = ReqReassign.find(params[:id])
      @req.assign_attributes(req_params)
      if @req.send(action)
        flash[:success] = 'req_updated_successfuly'
        redirect_to @req
      else
        render 'edit'
      end      
    end
  end  

  private

  def req_params
    params.require(:req_reassign).permit(:name, :manager, :inn, :money, :old_manager)
  end     
end
