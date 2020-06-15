class Photo < ApplicationRecord
  has_attached_file :file, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :file, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  # has_one_attached :file
  # validates :file, attached: true

  belongs_to :page, class_name: "Comfy::Cms::Page", optional: true

  # Only use if your ActiveStorage service is set to :local - this will give you the local file path
  def file_path
    ActiveStorage::Blob.service.send(:path_for, file.key)
  end
end
