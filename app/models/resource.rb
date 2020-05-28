class Resource < ApplicationRecord
  has_attached_file :file
  do_not_validate_attachment_file_type :file

  belongs_to :page, class_name: "Comfy::Cms::Page", optional: true
end
