module PhotosLinksResources
  extend ActiveSupport::Concern

  included do
    before_action :create_photos, only: [:create, :update]
    before_action :create_related_links, only: [:create, :update]
    before_action :create_resources, only: [:create, :update]

    def create_photos
      @page.save!
      return unless params[:images]

      params[:images].each do |image|
        image = @page.photos.new(file: image)
        redirect_if_error(image)
      end
    end

    def create_related_links
      return unless params[:related_links]

      params[:related_links].each do |related_link|
        link = @page.related_links.new(label: related_link[:label], url: related_link[:url])
        redirect_if_error(link)
      end
    end

    def create_resources
      return unless params[:resources]

      params[:resources].each do |resource|
        resource = @page.resources.new(label: resource[:label], file: resource[:file])
        redirect_if_error(resource)
      end
    end

    def redirect_if_error(object)
      unless object.save
        flash[:error] = object.errors.full_messages.join(', ')
        redirect_to action: :edit
      end
    end
  end
end

Comfy::Admin::Cms::PagesController.send(:include, PhotosLinksResources)
