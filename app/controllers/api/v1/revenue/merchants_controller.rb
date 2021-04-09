class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if quantity_param.positive?
      render json: MerchantNameRevenueSerializer.new(Merchant.top_by_revenue(quantity_param))
    else
      head :bad_request
    end
  end

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

  private

  def quantity_param
    params[:quantity].to_i
  end
end
