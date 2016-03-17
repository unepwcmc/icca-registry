class Api::CountriesController < ApplicationController
  def show
    render json: Country.find_by_iso_3(params[:id]).as_json(include: {
      icca_sites: {
        include: {pages: {
          include: :site, only: [:label, :full_path]}
        }
      }
    })
  end
end
