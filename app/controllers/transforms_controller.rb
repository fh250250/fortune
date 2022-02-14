class TransformsController < ApplicationController

  def index
    @s2t_transform = Transform.new config: "s2t"
    @t2s_transform = Transform.new config: "t2s"
  end

  def create
  end

end
