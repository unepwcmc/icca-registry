module IccaPhotos
  extend ActiveSupport::Concern

  included do
    before_action :create_photos, :only => [:create, :update]

    def create_photos
      @page.save!
      return unless params[:images]

      params[:images].each do |image|
        @page.photos.create(file: image)
      end
    end
  end
end

Comfy::Admin::Cms::PagesController.send(:include, IccaPhotos)
