class Api::V1::Revenue::MerchantsController < ApplicationController
  def show
    merchant_id = params[:id]

    if Merchant.exists?(merchant_id)
      merchant = Merchant.find(merchant_id)
      render json: MerchantRevenueSerializer.new(merchant)
    else
      merchant = OpenStruct.new({ id: nil, total_revenue: nil })
      render json: MerchantRevenueSerializer.new(merchant), status: :not_found
    end
  end
end
