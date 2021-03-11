class Admin::IccaSitesController < Comfy::Admin::Cms::BaseController
  before_action :set_icca_site, only: [:edit, :update, :destroy]

  def index
    @icca_sites = IccaSite.order(:name).all
  end

  def edit
  end

  def update
    name = icca_site_params[:name]

    updated_site = @icca_site.update(icca_site_params)

    if updated_site
      # CMS pages do not automatically update to reflect the new name of the ICCA site!
      normalised_name = I18n.transliterate(name).gsub(/[():'&]/, '')

      @icca_site.pages.update(
        label: name,
        slug: normalised_name.downcase.split.join('-')
      )
      redirect_to action: :index
    else
      flash[:error] = @icca_site.errors.full_messages.join(', ')
      redirect_to action: :edit
    end
  end

  def destroy
    if @icca_site.destroy
      flash[:notice] = "Site - #{@icca_site.name} deleted."
    else
      flash[:error] = @icca_site.errors.full_messages.first
    end

    redirect_to action: :index
  end

  private

  def set_icca_site
    @icca_site = IccaSite.find(params[:id])
  end

  def icca_site_params
    params.require(:icca_site).permit(:lat, :lon, :name)
  end
end

