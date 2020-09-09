class NewsArticlesController < ApplicationController
  def index
    _options = {
      page: news_params[:requested_page],
      size: news_params[:items_per_page]
    }
    results = @cms_page.children.where(is_published: true)

    @results = NewsSerializer.new(results, _options).serialize

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

  private

  def news_params
    params.permit(:requested_page, :items_per_page, :filters)
  end
end