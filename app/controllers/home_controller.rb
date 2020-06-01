class HomeController < ApplicationController
  def index
    # At the moment, website breaks as there are photos without attachments that were not migrated properly - @photo value is a placeholder
    @photo            = ActiveStorage::Attachment.last.record
    @last_case_study  = @photo.page
    @icca_site        = IccaSite.find(@last_case_study.icca_site_id)
  end
end
