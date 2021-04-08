class Api::V1::Merchants::MostRevenueController < ApplicationController
  def index
    render json: MerchantNameRevenueSerializer.new(top_by_revenue(quantity_param))
  end

  private

  def top_by_revenue(quantity)
    Merchant.top_by_revenue(quantity)
  end

  def quantity_param
    params[:quantity]
  end
end
