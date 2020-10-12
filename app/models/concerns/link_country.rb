module LinkCountry
  extend ActiveSupport::Concern

  included do
    belongs_to :country, optional: true

    before_save :link_country

    def link_country
      return true if parent.try(:label) != 'Explore'

      country = Country.find_or_create_by(name: label)
      self.country = country

      children.each do |child|
        icca_site = IccaSite.find_or_create_by(name: child.label)
        icca_site.country = country
        icca_site.save

        child.icca_site = icca_site
        child.save
      end
    end
  end
end

Comfy::Cms::Page.send(:include, LinkCountry)
