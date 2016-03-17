class Admin::CountriesController < Comfy::Admin::Cms::BaseController
  def index
    @countries = Country.order(:name).all
  end

  def edit
    @country = Country.find(params[:id])
  end

  def update
    @country = Country.find(params[:id])
    @country.update(country_params)
    redirect_to action: :index
  end

  private

  def country_params
    params.require(:country).permit(:iso_3, :name)
  end
end
