class ApplicationController < ActionController::API
  def per_page
    @per_page ||= params[:per_page] || 20
  end

  def page_number
    @page_number ||= params[:page] || 1
  end

  helper_method :params_per_page, :params_page_number
end
