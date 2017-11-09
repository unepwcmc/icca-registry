class HomeController < ApplicationController
  def index
    @photo            = Photo.order("created_at DESC").first
    @last_case_study  = @photo.page
    @icca_site        = IccaSite.find(@last_case_study.icca_site_id)
  end
end
