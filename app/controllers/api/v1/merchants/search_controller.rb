class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if name.empty?
      render json: bad_request, status: :bad_request
    else
      # render json: find_one_response(params[:name])
    end
  end

  private

  def find_one_response

  end

  def bad_request
    {
      code: 400,
      status: 'Invalid Query Parameter'
    }
  end
end
