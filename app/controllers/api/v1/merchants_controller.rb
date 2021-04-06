class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(paginate(all_merchants))
  end

  def show
    id_param = params[:id]

    if Merchant.exists?(id_param)
      render json: MerchantSerializer.new(Merchant.find(id_param))
    else
      render json: MerchantSerializer.new(null_merchant), status: :not_found
    end
  end

  private

  def null_merchant
    OpenStruct.new(id: nil, name: nil)
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
