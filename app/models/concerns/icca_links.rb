module IccaLinks
  extend ActiveSupport::Concern

  included do
    belongs_to :country
    belongs_to :icca_site

    has_many :photos
    has_many :resources
    has_many :related_links

    before_save :link_icca_site, dependent: :destroy
    before_save :link_country, dependent: :destroy

    def link_icca_site
      return if self.parent.country_id.nil?

      self.icca_site = IccaSite.find_or_create_by(
        name: self.label,
        country: self.parent.country
      )
    end

    def link_country
      return if self.parent.label != "Explore"

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
