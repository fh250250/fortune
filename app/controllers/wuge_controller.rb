class WugeController < ApplicationController

  def calc_show
  end

  def calc
    @wuge = Wuge.new calc_params
  end

  private

    def calc_params
      params.require(:wuge_calc).permit(:surname, :name)
    end

end
