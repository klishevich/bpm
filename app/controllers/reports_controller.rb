class ReportsController < ApplicationController

  def index
  end

  def sla
  	@assignments = Assignment.all
  end

end
