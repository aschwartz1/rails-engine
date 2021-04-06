class Api::V1::Revenue::MerchantsController < ApplicationController
  def show
    merchant_id = params[:id]
    merchant = Merchant.find(merchant_id)

    render json: MerchantRevenueSerializer.new(merchant)
  end
end
