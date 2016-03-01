class Country < ActiveRecord::Base
  has_many :icca_sites
  has_one :page, class_name: "Comfy::Cms::Page"
end
