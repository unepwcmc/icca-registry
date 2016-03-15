class IccaSite < ActiveRecord::Base
  belongs_to :country
  has_many :pages, class_name: "Comfy::Cms::Page"
end
