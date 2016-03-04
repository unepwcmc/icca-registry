class Admin::RelatedLinksController < Comfy::Admin::Cms::BaseController
  def destroy
    resource = RelatedLink.find(params[:id])
    resource.destroy

    redirect_to :back
  end
end
