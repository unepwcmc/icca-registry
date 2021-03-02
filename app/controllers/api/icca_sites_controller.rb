class Api::IccaSitesController < ApplicationController
  def index
    site  = Comfy::Cms::Site.find_by_locale(I18n.locale)

    valid_sites = IccaSite.includes(:pages).where(comfy_cms_pages: { site_id: site.id }).where.not(lat: nil, lon: nil)

    render json: valid_sites.all.as_json(include: { pages: { include: :site, only: [:label, :full_path] } })
  end
end
