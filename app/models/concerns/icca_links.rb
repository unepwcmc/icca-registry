module IccaLinks
  extend ActiveSupport::Concern

  included do
    has_many :photos, dependent: :destroy
    has_many :resources, dependent: :destroy
    has_many :related_links, dependent: :destroy

    include PgSearch

    multisearchable against: :label

    belongs_to :country, optional: true
    belongs_to :icca_site, optional: true, dependent: :destroy

    before_save :link_icca_site
    before_save :link_country

    def link_icca_site
      return true if parent.try(:country_id).nil?

      if icca_site
        IccaSite.where(id: icca_site.id).update(name: label)
        normalised_label = I18n.transliterate(label).gsub(/[():']/, '')
        self.slug = normalised_label.downcase.split.join('-')
      else
        self.icca_site = IccaSite.find_or_create_by(
          name: label,
          country: parent.country
        )
      end
    end

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

Comfy::Cms::Page.send(:include, IccaLinks)
