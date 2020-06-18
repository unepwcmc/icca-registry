class Admin::RelatedLinksController < Comfy::Admin::Cms::BaseController
  def destroy
    resource = RelatedLink.find(params[:id])
    resource.destroy

    redirect_back(fallback_location: admin_icca_site_path)
  end
end
