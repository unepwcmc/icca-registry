class Api::IccaSitesController < ApplicationController
  def index
    site  = Comfy::Cms::Site.find_by_locale(I18n.locale)

    render json: IccaSite.includes(:pages).where(comfy_cms_pages: {site_id: site.id}).all.as_json(
      include: {pages: {include: :site, only: [:label, :full_path]}}
    )
  end
end
