module FragmentSearch
  extend ActiveSupport::Concern
  # Enable fragments to be indexed in the search
  included do
    include PgSearch

    multisearchable against: :content, if: -> (record) { record.identifier == 'content' }
  end
end

Comfy::Cms::Fragment.send(:include, FragmentSearch)