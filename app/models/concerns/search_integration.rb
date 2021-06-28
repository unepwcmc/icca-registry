module FragmentSearch
  extend ActiveSupport::Concern
  # Enable fragments to be indexed in the search
  included do
    include PgSearch

    multisearchable against: :content, if: -> (record) { record.identifier == 'content' }
  end
end

module PageSearch
  extend ActiveSupport::Concern

  included do 
    include PgSearch

    multisearchable against: :label
  end
end

# DESTINATIONS
Comfy::Cms::Fragment.send(:include, FragmentSearch)
Comfy::Cms::Page.send(:include, PageSearch)