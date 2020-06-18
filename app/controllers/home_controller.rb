class HomeController < ApplicationController
  def index
    # pages = Comfy::Cms::Page
    # site  = Comfy::Cms::Site.find_by_locale(I18n.locale)

    # @explore_page     = pages.find_by_slug_and_site_id("explore", site.id)

    # Website breaks if there are photos without attachments - so @photo defaults to the latest safe option
    @photo            = ActiveStorage::Attachment.where(record_type: 'Photo').last.record
    @last_case_study  = @photo.page
    @icca_site        = IccaSite.find(@last_case_study.icca_site_id)
  end
end
