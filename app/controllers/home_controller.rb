class HomeController < ApplicationController

  def index
    @search = BaseDrugHosp.new
  end

end