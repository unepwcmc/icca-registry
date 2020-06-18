class Admin::ResourcesController < Comfy::Admin::Cms::BaseController
  def destroy
    resource = Resource.find(params[:id])
    resource.destroy

    redirect_back(fallback_location: admin_icca_site_path)
  end
end
