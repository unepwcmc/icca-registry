Rails.configuration.to_prepare do
    Comfy::Cms::Page.class_eval do 
        has_many :photos, dependent: :destroy
        has_many :resources, dependent: :destroy
        has_many :related_links, dependent: :destroy

        include PgSearch

        multisearchable against: :label

        belongs_to :country, optional: true
        belongs_to :icca_site, optional: true, dependent: :destroy
        
        before_save :link_icca_site, dependent: :destroy
        before_save :link_country, dependent: :destroy
    
        def link_icca_site
            return true if self.parent.try(:country_id).nil?
    
            if self.icca_site 
                IccaSite.where(id: self.icca_site.id).update(name: self.label)
                normalised_label = I18n.transliterate(self.label)
                self.slug = normalised_label.downcase.split.join('-')
            else
                self.icca_site = IccaSite.find_or_create_by(
                    name: self.label,
                    country: self.parent.country
                )
            end
        end
    
        def link_country
            return true if self.parent.try(:label) != "Explore"
    
            country = Country.find_or_create_by(name: self.label)
            self.country = country
    
            self.children.each do |child|
                icca_site = IccaSite.find_or_create_by(name: child.label)
                icca_site.country = country
                icca_site.save
        
                child.icca_site = icca_site
                child.save
            end
        end
    end

    Comfy::Cms::Fragment.class_eval do
        include PgSearch

        multisearchable against: :content, if: -> (record) { record.identifier == "content" }
    end
end