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

  def create
    item = Item.new(item_params)

    if verify_item_params(item_params)
      if item.save
        render json: ItemSerializer.new(item), status: :created
      else
        render json: save_failed, status: :internal_server_error
      end
    else
      render json: bad_request('Invalid Item Data'), status: :bad_request
    end
  end

  def update
    head :not_found and return unless valid_merchant_param?

    item = Item.find_by(id: params[:id])

    if item
      item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      head :not_found
    end
  end

  def destroy
    destroyer = ItemDestroyer.new(params[:id])
    destroyer.destroy

    return if destroyer.error.empty?

    render json: bad_request(destroyer.error), status: :bad_request
  end

  private

  def valid_merchant_param?
    # No merchant param is valid
    return true unless item_params.include?(:merchant_id)

    # If merchant param present, make sure it is valid
    Merchant.exists?(item_params[:merchant_id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def verify_item_params(params)
    expected_keys = %i[name description unit_price merchant_id]

    expected_keys.all? do |key|
      params.key? key
    end && params.keys.size == 4
  end

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

  def bad_request(status)
    {
      code: 400,
      status: status
    }
  end

  def save_failed
    {
      code: 500,
      status: 'Failed to Save Item'
    }
  end
end
