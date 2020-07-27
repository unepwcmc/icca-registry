module IccaPhotos
  extend ActiveSupport::Concern

  included do
    before_action :create_photos, :only => [:create, :update]

    def create_photos
      @page.save!
      return unless params[:images]

      params[:images].each do |image|
        image = @page.photos.new(file: image)
        unless image.save
          flash[:error] = image.errors.full_messages.join(', ')
          redirect_to action: :edit
        end
      end
    end
  end
end

Comfy::Admin::Cms::PagesController.send(:include, IccaPhotos)
