class MakenameController < ApplicationController

  def index
  end

  def make
    @maker = NameMaker.new maker_params
    @maker.make
  end

  private

    def maker_params
      params.require(:makename).permit(:surname)
    end

end
