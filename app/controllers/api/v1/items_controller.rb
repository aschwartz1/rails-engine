class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(paginate(all_items))
  end

  def show
    id_param = params[:id]

    if Item.exists?(id_param)
      render json: ItemSerializer.new(Item.find(id_param))
    else
      render json: ItemSerializer.new(null_item), status: :not_found
    end
  end

  private

  def null_item
    OpenStruct.new(id: nil, name: nil, description: nil, unit_price: nil)
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

  def all_items
    Item.all_limit(records_needed_for_request)
  end

  def minimum(num1, num2)
    [num1, num2].min
  end
end
