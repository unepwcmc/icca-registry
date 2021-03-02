class IccaSite < ApplicationRecord
  before_destroy :safe_to_destroy, prepend: true
  belongs_to :country
  has_many :pages, class_name: "Comfy::Cms::Page"

  validates :lon, allow_blank: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180, message: "must be within +/- 180 and must only contain numbers and/or a '.'" }
  validates :lat, allow_blank: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90, message: "must be within +/- 90 and must only contain numbers and/or a '.'" } 

  private

  def safe_to_destroy
    if pages.any?
      errors[:base] << "Attempted to delete #{self.name}, but pages found associated with that site. Delete those pages and try again."
      throw :abort
    end
  end

end
