require 'active_storage'
require 'pg_search'
require 'comfortable_mexican_sofa'

Comfy::Cms::Fragment.class_eval do
    include PgSearch
    multisearchable against: :content, if: -> (record) { record.identifier == "content" }
end
  