class KangxisController < ApplicationController

  def index
    @kangxis = Kangxi.order(:strokes).page(params[:page])
  end

end
