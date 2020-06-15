class Admin::IccaSitesController < Comfy::Admin::Cms::BaseController
  before_action :set_icca_site, only: [:edit, :update, :destroy]

  def index
    @icca_sites = IccaSite.order(:name).all
  end

  def edit
  end

  def update
    @icca_site.update(icca_site_params)

    redirect_to action: :index
  end

  def destroy
    flash[:notice] = "Site #{@icca_site.name} deleted."

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

