class ReqReassignsController < ApplicationController
  def index
  	@reqs = ReqReassign.all
  end

  def new
    @req = ReqReassign.new
  end

  def create
    @req = ReqReassign.new(req_params)
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
    params.require(:req_reassign).permit(:name, :manager, :inn, :money)
  end     
end
