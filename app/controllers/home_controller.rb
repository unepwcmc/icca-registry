class HomeController < ApplicationController
  def index
    @last_case_study = Comfy::Cms::Page.published.order(:created_at).last
  end
end
