class HomeController < ApplicationController
  def index
    @last_case_study = Photo.order(:created_at).first.page
  end
end
