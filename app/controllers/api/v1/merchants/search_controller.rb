class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if name.empty?
      render json: bad_request, status: :bad_request
    else
      merchant = search_result(name)
      render json: success_response(merchant)
    end
  end

  private

  def success_response(merchant)
    if merchant
      MerchantSerializer.new(merchant)
    else
      { data: {} }
    end
  end

  def search_result(search_name)
    Merchant.find_one_by_name(search_name)
  end

  def bad_request
    {
      code: 400,
      status: 'Invalid Query Parameter'
    }
  end
end
