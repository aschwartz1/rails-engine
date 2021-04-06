class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if name.empty?
      render json: bad_request, status: :bad_request
    else
      render json: find_one_response(name)
    end
  end

  private

  def find_one_response(search_name)
    {
      data: format_merchant(search_result(search_name))
    }
  end

  def search_result(search_name)
    Merchant.find_one_by_name(search_name)
  end

  def format_merchant(merchant)
    # TODO: duplicate, also in merchants_controller.rb
    #   Well, almost. The other one doesn't handle a nil merchant
    if merchant
      {
        id: merchant.id.to_s,
        type: 'merchant',
        attributes: merchant_attributes(merchant)
      }
    else
      {}
    end
  end

  def merchant_attributes(merchant)
    # TODO: duplicate, also in merchants_controller
    {
      name: merchant.name
    }
  end

  def bad_request
    {
      code: 400,
      status: 'Invalid Query Parameter'
    }
  end
end
