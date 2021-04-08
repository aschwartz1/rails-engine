class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    # render json: ItemSerializer.new(paginate(merchant_items))
  end
end
