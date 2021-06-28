class SearchController < ApplicationController
  include SearchModule

  def show
    @query = params[:q]
    @results = SearchModule.results(params[:q])
    categorize_results
  end

  def categorize_results
    @countries = @results.select { |result| result.country.present? }
    @case_studies = @results.select { |result| result.icca_site.present? }
  end
end
