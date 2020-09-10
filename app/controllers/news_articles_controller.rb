class NewsArticlesController < ApplicationController
  def index
    _options = {
      page: news_params[:requested_page],
      size: news_params[:items_per_page]
    }

    news_page = @site.pages.find_by_slug('news-and-stories')
    results = news_page.children.where(is_published: true)

    @results = NewsSerializer.new(results, _options).serialize

    render json: @results
  end

  private

  def news_params
    params.permit(:requested_page, :items_per_page, :filters)
  end
end