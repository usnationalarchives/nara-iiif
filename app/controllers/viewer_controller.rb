class ViewerController < ApplicationController

  def show
    @item = Item.find(params[:id])
  end

end