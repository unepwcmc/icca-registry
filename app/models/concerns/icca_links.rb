module IccaLinks
  extend ActiveSupport::Concern

  included do
    belongs_to :country, optional: true
    belongs_to :icca_site, optional: true, dependent: :destroy

    has_many :photos
    has_many :resources
    has_many :related_links

    before_save :link_icca_site, dependent: :destroy
    before_save :link_country, dependent: :destroy

    def link_icca_site
      return true if self.parent.try(:country_id).nil?
      
      if self.icca_site 
        IccaSite.where(id: self.icca_site.id).update(name: self.label)
        self.slug = self.label.downcase.split().join('-')
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

end



Comfy::Cms::Page.send(:include, IccaLinks)
