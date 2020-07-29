class Admin::CountriesController < Comfy::Admin::Cms::BaseController
  before_action :set_country, only: [:edit, :update, :destroy]

  def index
    @countries = Country.order(:name).all
  end

  def edit
  end

  def update
    @country.update(country_params)
    redirect_to action: :index
  end

  def destroy
    if @country.destroy
      flash[:notice] = "Country - #{@country.name} deleted."
    else
      flash[:error] = @country.errors.full_messages.first
    end

    redirect_to action: :index
  end

  private

  def set_country
    @country = Country.find(params[:id])
  end

  def country_params
    params.require(:country).permit(:iso_3, :name)
  end
end
