module LinkIccaSite
  extend ActiveSupport::Concern

  included do
    belongs_to :icca_site, optional: true, dependent: :destroy

    before_save :link_icca_site

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
  end
end

# DESTINATIONS
Comfy::Cms::Page.send(:include, LinkIccaSite)