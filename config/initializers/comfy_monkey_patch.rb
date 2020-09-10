Rails.configuration.to_prepare do
  Comfy::Cms::Page.class_eval do
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

  Comfy::Cms::Fragment.class_eval do
    include PgSearch

    multisearchable against: :content, if: -> (record) { record.identifier == 'content' }
  end

  Comfy::Admin::Cms::PagesController.class_eval do
    before_action :create_photos, only: [:create, :update]
    before_action :create_related_links, only: [:create, :update]
    before_action :create_resources, only: [:create, :update]

    def create_photos
      @page.save!
      return unless params[:images]

      params[:images].each do |image|
        image = @page.photos.new(file: image)
        unless image.save
          flash[:error] = image.errors.full_messages.join(', ')
          redirect_to action: :edit
        end
      end
    end

    def create_related_links
      return unless params[:related_links]

      params[:related_links].each do |related_link|
        link = @page.related_links.new(label: related_link[:label], url: related_link[:url])
        unless link.save
          flash[:error] = link.errors.full_messages.join(', ')
          redirect_to action: :edit
        end
      end
    end

    def create_resources
      return unless params[:resources]

      params[:resources].each do |resource|
        resource = @page.resources.new(label: resource[:label], file: resource[:file])
        unless resource.save
          flash[:error] = resource.errors.full_messages.join(', ')
          redirect_to action: :edit
        end
      end
    end
  end
end
