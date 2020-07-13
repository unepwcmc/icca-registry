class HomeController < ApplicationController
  def index
    # Website breaks if there are photos without attachments - so @photo defaults to the latest safe option
    site  = Comfy::Cms::Site.find_by_locale(I18n.locale)
    @last_case_study  = Comfy::Cms::Page.where(is_published: true, site_id: site.id).where.not(icca_site_id: nil).last  
    @photo            = @last_case_study.photos.first if @last_case_study.photos.any?
    @icca_site        = IccaSite.find(@last_case_study.icca_site_id)
  end

end
