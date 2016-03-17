class Api::IccaSitesController < ApplicationController
  def index
    render json: IccaSite.all.as_json(include: {
      pages: {include: :site, only: [:label, :full_path]}
    })
  end
end
