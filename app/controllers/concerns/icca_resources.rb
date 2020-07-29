module IccaResources
  extend ActiveSupport::Concern

  included do
    before_action :create_resources, :only => [:create, :update]

    def create_resources
      return unless params[:resources]

      params[:resources].each do |resource|
        resource = @page.resources.new(label: resource[:label], file: resource[:file])
        unless resource.save
          flash[:error] = resource.errors.full_messages.join(', ')
          redirect_to action: :edit
        end
      end
    end
  end
end

Comfy::Admin::Cms::PagesController.send(:include, IccaResources)
