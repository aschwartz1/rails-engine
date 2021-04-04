class ApplicationController < ActionController::API
  include ActionController::Helpers

  def per_page
    @per_page ||= fetch_per_page
  end

  def page_number
    @page_number ||= fetch_page_number
  end

  private

  def fetch_per_page
    per_page_param = params[:per_page].to_i

    if per_page_param.positive?
      per_page_param
    else
      20
    end
  end

  def fetch_page_number
    page_param = params[:page].to_i

    if page_param.positive?
      page_param
    else
      1
    end
  end

  helper_method :per_page, :page_number
end
