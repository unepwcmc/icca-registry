class Resource < ApplicationRecord
  has_one_attached :file
  validates :file, attached: true

  belongs_to :page, class_name: "Comfy::Cms::Page", optional: true

  # Only use if your ActiveStorage service is set to :local - this will give you the local file path
  def file_path
    ActiveStorage::Blob.service.send(:path_for, file.key)
  end
end
