module SearchIntegration
  module ForFragments
    extend ActiveSupport::Concern
    included do
      include PgSearch
      multisearchable against: :content, if: -> (record) { record.identifier == "content" }
    end
  end

  module ForPages
    extend ActiveSupport::Concern
    included do
      include PgSearch
      multisearchable against: :label
    end
  end
end

Comfy::Cms::Page.send(:include, SearchIntegration::ForPages)

# Search integratoin for fragments is broken
# Comfy::Cms::Fragment.send(:include, SearchIntegration::ForFragments)
