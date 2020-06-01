class Photo < ApplicationRecord
  # has_attached_file :file
  has_one_attached :file
  validates :file, attached: true

  belongs_to :page, class_name: "Comfy::Cms::Page", optional: true

  def file_path
    ActiveStorage::Blob.service.send(:path_for, file.key)
  end
end
