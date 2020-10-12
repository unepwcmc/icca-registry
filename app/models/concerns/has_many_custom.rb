module HasManyCustom
  extend ActiveSupport::Concern

  included do
    has_many :photos, dependent: :destroy
    has_many :resources, dependent: :destroy
    has_many :related_links, dependent: :destroy
  end
end

# DESTINATIONS
Comfy::Cms::Page.send(:include, HasManyCustom)