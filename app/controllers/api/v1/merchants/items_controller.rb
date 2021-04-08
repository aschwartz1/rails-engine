class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    if Merchant.exists?(params[:id])
      render json: ItemSerializer.new(merchant_items)
    else
      head :not_found
    end
  end

  private

  def merchant_items
    merchant = Merchant.find_by(id: params[:id])

    merchant.items if merchant
  end
end
