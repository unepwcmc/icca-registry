class HomeController < ApplicationController
  def index
    # Website breaks if there are photos without attachments - so @photo defaults to the latest safe option
    site  = Comfy::Cms::Site.find_by_locale(I18n.locale)
    @last_case_study  = Comfy::Cms::Page.where(is_published: true, site_id: site.id).last  
    @photo            = find_last_photo.record unless find_last_photo.nil?
    @icca_site        = IccaSite.find(@last_case_study.icca_site_id)
  end

  def find_last_photo
    ActiveStorage::Attachment.where(record_type: 'Photo').find do |photo| 
      photo.record.page_id == @last_case_study.id 
    end
  end
end
