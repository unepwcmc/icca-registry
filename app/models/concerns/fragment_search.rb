Rails.configuration.to_prepare do
  # Enable fragments to be indexed in the search
  Comfy::Cms::Fragment.class_eval do
    include PgSearch

    multisearchable against: :content, if: -> (record) { record.identifier == 'content' }
  end

end
