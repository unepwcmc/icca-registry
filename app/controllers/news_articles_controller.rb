class NewsArticlesController < ApplicationController
  def index
    _options = {
      page: news_params[:requested_page],
      per_page: news_params[:items_per_page]
    }

    @results = NewsSerializer.new(@cms_page.children.where(is_published: true), _options).serialize
    respond_to do |format|
      format.html
      format.js { render json: @results }
    end
  end

  private

  def news_params
    params.permit(:type, :requested_page, :items_per_page, :filters)
  end
end