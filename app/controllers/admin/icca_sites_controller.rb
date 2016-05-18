class Admin::IccaSitesController < Comfy::Admin::Cms::BaseController
  def index
    @icca_sites = IccaSite.order(:name).all
  end

  def edit
    @icca_site = IccaSite.find(params[:id])
  end

  def update
    @icca_site = IccaSite.find(params[:id])
    @icca_site.update(icca_site_params)

    redirect_to action: :index
  end

  private

  def icca_site_params
    params.require(:icca_site).permit(:lat, :lon, :name)
  end
end

