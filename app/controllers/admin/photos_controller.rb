class Admin::PhotosController < Comfy::Admin::Cms::BaseController
  def destroy
    photo = Photo.find(params[:id])
    photo.destroy

    redirect_back(fallback_location: admin_icca_site_path)
  end
end
