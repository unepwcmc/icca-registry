class Resource < ActiveRecord::Base
  has_attached_file :file
  do_not_validate_attachment_file_type :file

  belongs_to :page, class_name: "Comfy::Cms::Page"
end
