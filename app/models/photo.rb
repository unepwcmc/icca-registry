class Photo < ApplicationRecord
  has_attached_file :file, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :file, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  belongs_to :page, class_name: "Comfy::Cms::Page", optional: true
end
