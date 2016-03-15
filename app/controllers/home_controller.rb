class HomeController < ApplicationController
  def index
    @last_case_study = IccaSite.order(:created_at).last.pages.first
  end
end
