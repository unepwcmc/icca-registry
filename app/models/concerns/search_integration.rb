module SearchForPages
  extend ActiveSupport::Concern
  included do
    include PgSearch
    multisearchable against: :label
  end
end


module FragmentSearch
  extend ActiveSupport::Concern
  included do
    include PgSearch
    multisearchable against: :content, if: -> (record) { record.identifier == "content" }
  end
end


Comfy::Cms::Page.send(:include, SearchForPages)
Comfy::Cms::Fragment.send(:include, FragmentSearch)
