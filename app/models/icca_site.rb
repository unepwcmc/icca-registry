class IccaSite < ApplicationRecord
  belongs_to :country
  has_many :pages, class_name: "Comfy::Cms::Page", dependent: :destroy

end
