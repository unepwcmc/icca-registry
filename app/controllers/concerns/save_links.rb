module SaveLinks
  extend ActiveSupport::Concern

  included do
    before_action :create_related_links, only: [:create, :update]

    def create_related_links
      return unless params[:related_links]

      params[:related_links].each do |related_link|
        link = @page.related_links.new(label: related_link[:label], url: related_link[:url])
        redirect_if_error(link)
      end
    end
  end
end

Comfy::Admin::Cms::PagesController.send(:include, SaveLinks)