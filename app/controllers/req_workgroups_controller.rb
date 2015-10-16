class ReqWorkgroupsController < ApplicationController
  before_action :authenticate_user!
  before_filter :not_assigned, only: [:edit, :update]

  def index
  	@reqs = ReqWorkgroup.all.order('id desc') #where('state not in (?)', 'closed').order('id desc')
  end

  def new
    @req = ReqWorkgroup.new
  end

  def create
    @req = ReqWorkgroup.new(req_params)
    @req.set_last_user(current_user)
    if @req.save
      redirect_to @req
    else
      render 'new'
    end  
  end

  def show
    @req = ReqWorkgroup.find(params[:id])
    @history = @req.history 	
  end

  def edit
    @req=ReqWorkgroup.find(params[:id])
  end

  def update
    @req = ReqWorkgroup.find(params[:id])
    @req.set_last_user(current_user)
    action = params[:commit]
    Rails.logger.info('!!!!!'+action) if action
    if action == 'save'
      if @req.update_attributes(req_params)
        flash[:success] = 'req_updated_successfuly'
        redirect_to @req
      else
        render 'edit'
      end
    else
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
    params.require(:req_workgroup).permit(:name, :money, :description, 
      inf_workgroup_members_attributes: [:id, :user_id, :main, :comment, :_destroy])
  end     

  def not_assigned
    req = ReqWorkgroup.find(params[:id])
    unless req.is_assigned?(current_user)
      redirect_to root_path
    end   
  end

end
