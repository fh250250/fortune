class KangxisController < ApplicationController

  def index
    @kangxis = Kangxi.order(:strokes).page(params[:page]).per(120)
  end

end
