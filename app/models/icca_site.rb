class IccaSite < ApplicationRecord
  before_destroy :safe_to_destroy, prepend: true
  belongs_to :country
  has_many :pages, class_name: "Comfy::Cms::Page"

  validates :lon, :lat, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180, message: 'must be valid' }

  private

  def safe_to_destroy
    if pages.any?
      errors[:base] << "Attempted to delete #{self.name}, but pages found associated with that site. Delete those pages and try again."
      throw :abort
    end
  end

end
