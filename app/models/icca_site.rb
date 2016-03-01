class IccaSite < ActiveRecord::Base
  belongs_to :country
  has_one :page, class_name: "Comfy::Cms::Page"
end
