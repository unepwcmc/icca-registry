module SaveResources
  extend ActiveSupport::Concern

  included do
    before_action :create_resources, only: [:create, :update]

    def create_resources
      return unless params[:resources]

      params[:resources].each do |resource|
        resource = @page.resources.new(label: resource[:label], file: resource[:file])
        redirect_if_error(resource)
      end
    end
  end
end

Comfy::Admin::Cms::PagesController.send(:include, SaveResources)
