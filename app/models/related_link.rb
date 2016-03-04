class RelatedLink < ActiveRecord::Base
  belongs_to :page, class_name: "Comfy::Cms::Page"
end
