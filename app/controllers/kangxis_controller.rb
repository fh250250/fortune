class KangxisController < ApplicationController

  def index
    @kangxis = Kangxi.order(strokes: :asc).limit(100)
  end

end
