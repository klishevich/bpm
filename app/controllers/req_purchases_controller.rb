class ReqPurchasesController < ApplicationController
  # before_action :authenticate_user!
  before_filter :not_assigned, only: [:edit, :update]

  def index
  	# @reqs = ReqPurchase.all.order('id desc')
   	@reqs = ReqPurchase.where('state not in (?)', 'closed').order('id desc')
  end

  def new
    @req = ReqPurchase.new
  end

  def create
    Rails.logger.info('!!!!! create')   	
    Rails.logger.info(params)   	
    # params[:req_purchase][:last_user_id] = current_user.id
    @req = ReqPurchase.new(req_params)
    @req.set_last_user(current_user)
    if @req.save
      redirect_to @req
    else
      render 'new'
    end  
  end

  def show
    @req = ReqPurchase.find(params[:id])
    @history = @req.history
    respond_to do |format|
      format.html       
    end  	
  end

  def edit
    @req=ReqPurchase.find(params[:id])
  end

  def update
  	# params['req_purchase'] = Hash.new
    # Rails.logger.info('!!!!! update')   	
    # Rails.logger.info(params)   	
    # params[:req_purchase][:last_user_id] = current_user.id
    @req = ReqPurchase.find(params[:id])
    @req.set_last_user(current_user)
    action = params[:commit]
    Rails.logger.info('!!!!!'+action) if action
    # Rails.logger.info(params.inspect)
    params.inspect
    if action == 'save'
      # @req = ReqPurchase.find(params[:id])
      if @req.update_attributes(req_params)
        flash[:success] = t(:req_updated_successfuly)
        redirect_to @req
      else
        render 'edit'
      end
    else
      # @req = ReqPurchase.find(params[:id])
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
    params.fetch(:req_purchase, Hash.new).permit(:name, :money, :last_user_id, :myfile, 
      :myfile_cache, :remove_myfile)
    # params.require(:req_purchase).permit(:name, :money, :last_user_id)
  end     

  def not_assigned
    req = ReqPurchase.find(params[:id])
    unless req.is_assigned?(current_user)
      redirect_to root_path
    end   
  end
end
