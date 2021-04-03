class Api::V1::MerchantsController < ApplicationController
  def index
    # render json: Merchant.all
    render json: (paginate(limited_merchants))
  end

  private

  def paginate(results)
    last_results_index = (results.size - 1)
    start_index = per_page * (page_number - 1)
    return [] if start_index > last_results_index
    end_index = minimum(last_results_index, (records_needed_for_request - 1))
    results[start_index..end_index]
  end

  def records_needed_for_request
    page_number * per_page
  end

  def limited_merchants
    Merchant.all_limit(records_needed_for_request)
  end

  def minimum(num_1, num_2)
    [num_1, num_2].min
  end
end
