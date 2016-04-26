class HomeController < ApplicationController
  def index
    @last_case_study = Photo.order("created_at DESC").first.page
  end
end
