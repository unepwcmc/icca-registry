class IccaSite < ApplicationRecord
  belongs_to :country
  has_many :pages, class_name: "Comfy::Cms::Page", dependent: :destroy
  before_destroy :safe_to_destroy

  private

  def safe_to_destroy
    if pages.any?
      errors[:base] << "Attempted to delete site, but pages found associated with that site. Delete those pages and try again."
      false
    end
  end

end
