class Resource < ApplicationRecord
  # has_attached_file :file

  has_one_attached :file
  validates :file, attached: true
  validates :label, presence: { message: "must not be blank" }

  belongs_to :page, class_name: "Comfy::Cms::Page", optional: true


  # Only use if your ActiveStorage service is set to :local - this will give you the local file path
  # for a particular Resource
  def file_path
    file_key = self.file.key
    ActiveStorage::Blob.service.send(:path_for, file_key)
  end
end
