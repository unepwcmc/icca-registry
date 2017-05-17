class Api::IccaSitesController < ApplicationController
  def index
    render json: IccaSite.includes(pages: :site).all.as_json(
      include: {pages: {include: :site, only: [:label, :full_path]}}
    )
  end
end
