class Admin::PhotosController < Comfy::Admin::Cms::BaseController
  def destroy
    photo = Photo.find(params[:id])
    photo.destroy

    redirect_to :back
  end
end
