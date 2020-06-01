class HomeController < ApplicationController
  def index
    # Website breaks if there are photos without attachments - so @photo defaults to the latest safe option
    @photo            = ActiveStorage::Attachment.last.record
    @last_case_study  = @photo.page
    @icca_site        = IccaSite.find(@last_case_study.icca_site_id)
  end
end
