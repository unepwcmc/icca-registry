Rails.configuration.to_prepare do
    Comfy::Cms::Page.class_eval do 
        has_many :photos, dependent: :destroy
        has_many :resources, dependent: :destroy
        has_many :related_links, dependent: :destroy

        include PgSearch

        multisearchable against: :label
    end

    Comfy::Cms::Fragment.class_eval do
        include PgSearch
        
        multisearchable against: :content, if: -> (record) { record.identifier == "content" }
    end
end