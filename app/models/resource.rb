class Resource < ApplicationRecord
  has_one_attached :file

  belongs_to :page, class_name: "Comfy::Cms::Page", optional: true
end
