class Api::V1::MerchantsController < ApplicationController
  def index
    render json: all_merchants_response
  end

  def show
    id_param = params[:id]

    if Merchant.exists?(id_param)
      render json: single_merchant_response(id_param)
    else
      render json: not_found, status: :not_found
    end
  end

  private

  def all_merchants_response
    {
      data: format_merchants(paginate(all_merchants))
    }
  end

  def format_merchants(merchants)
    merchants.map do |merchant|
      format_merchant(merchant)
    end
  end

  def merchant_attributes(merchant)
    {
      name: merchant.name
    }
  end

  def single_merchant_response(id)
    {
      data: format_merchant(Merchant.find(id))
    }
  end

  def format_merchant(merchant)
    {
      id: merchant.id.to_s,
      type: 'merchant',
      attributes: merchant_attributes(merchant)
    }
  end

  def not_found
    {
      code: 404,
      status: 'Not Found'
    }
  end

  def paginate(results)
    last_results_index = (results.size - 1)
    start_index = per_page * (page_number - 1)
    end_index = minimum(last_results_index, (records_needed_for_request - 1))

    if start_index > last_results_index
      []
    else
      results[start_index..end_index]
    end
  end

  def records_needed_for_request
    page_number * per_page
  end

  def all_merchants
    Merchant.all_limit(records_needed_for_request)
  end

  def minimum(num1, num2)
    [num1, num2].min
  end
end
