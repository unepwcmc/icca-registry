module SavePhotos
  extend ActiveSupport::Concern

  included do
    before_action :create_photos, only: [:create, :update]

    def create_photos
      @page.save!
      return unless params[:images]

      params[:images].each do |image|
        image = @page.photos.new(file: image)
        redirect_if_error(image)
      end
    end
  end
end

Comfy::Admin::Cms::PagesController.send(:include, SavePhotos)
