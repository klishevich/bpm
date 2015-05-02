class ReqReassignsController < ApplicationController
  def index
  	@reqs = ReqReassign.all
  end

  def new
  end

  def create
  end

  def show
    @req = ReqReassign.find(params[:id])
    respond_to do |format|
      format.html       
    end  	
  end
end
