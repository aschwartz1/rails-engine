class Api::V1::MerchantsController < ApplicationController
  def index
    # render json: Merchant.all
    render json: all_merchants_response
  end

  private

  def all_merchants_response
    {
      data: format_merchants(paginate(all_merchants))
    }
  end

  def format_merchants(merchants)
    merchants.map do |merchant|
      {
        id: merchant.id.to_s,
        type: 'merchant',
        attributes: merchant_attributes(merchant)
      }
    end
  end

  def merchant_attributes(merchant)
    {
      name: merchant.name
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

  def minimum(num_1, num_2)
    [num_1, num_2].min
  end
end
