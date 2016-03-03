module IccaResources
  extend ActiveSupport::Concern

  included do
    before_action :create_resources, :only => [:create, :update]

    def create_resources
      return unless params[:resources]

      params[:resources].each do |resource|
        @page.resources.create!(label: resource[:label], file: resource[:file])
      end
    end
  end
end

Comfy::Admin::Cms::PagesController.send(:include, IccaResources)
