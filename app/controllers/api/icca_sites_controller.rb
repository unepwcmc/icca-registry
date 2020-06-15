class Api::IccaSitesController < ApplicationController
  def index
    render json: IccaSite.includes(:pages).where.not(comfy_cms_pages: { id: nil }).as_json(
      include: {pages: {include: :site, only: [:label, :full_path]}}
    )
  end
end
