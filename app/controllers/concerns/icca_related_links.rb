module IccaRelatedLinks
  extend ActiveSupport::Concern

  included do
    before_action :create_related_links, :only => [:create, :update]

    def create_related_links
      return unless params[:related_links]

      params[:related_links].each do |related_link|
        @page.related_links.create!(label: related_link[:label], url: related_link[:url])
      end
    end
  end
end

Comfy::Admin::Cms::PagesController.send(:include, IccaRelatedLinks)
