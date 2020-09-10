Rails.configuration.to_prepare do
    Comfy::Cms::Fragment.class_eval do
        include PgSearch
        multisearchable against: :content, if: -> (record) { record.identifier == "content" }
    end
end