class RelatedLink < ApplicationRecord
  belongs_to :page, class_name: "Comfy::Cms::Page"
end
