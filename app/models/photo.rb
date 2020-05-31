class Photo < ApplicationRecord
  has_one_attached :file
  validates :file, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  belongs_to :page, class_name: "Comfy::Cms::Page", optional: true
end
