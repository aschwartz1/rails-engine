class ApplicationController < ActionController::API
  def per_page
    @per_page = params[:per_page] ? params[:per_page].to_i : 20
  end

  def page_number
    @page_number = params[:page] ? params[:page].to_i : 1
  end

  helper_method :per_page, :page_number
end
