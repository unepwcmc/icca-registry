module SearchForPages
  extend ActiveSupport::Concern
  included do
    include PgSearch
    multisearchable against: :label
  end
end

Comfy::Cms::Page.send(:include, SearchForPages)
