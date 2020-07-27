class RelatedLink < ApplicationRecord
  require 'uri' 

  belongs_to :page, class_name: "Comfy::Cms::Page", optional: true
  validates :label, :url, presence: { message: "must not be empty" }
  validates :url, format: { with: /#{URI.regexp}/, message: "must be valid" }
  

end
