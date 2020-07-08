class SearchController < ApplicationController
  include PgSearch

  def show
    @query = params[:q]
    @results = Search.results(params[:q])
    categorize_results
  end

  def categorize_results
    @countries = @case_studies = []

    @results.each do |result|
      if result.country.present?
        @countries << result
      elsif result.icca_site.present?
        @case_studies << result
      end
    end
  end
end
