class Country < ApplicationRecord
  before_destroy :safe_to_destroy, prepend: true
  has_many :icca_sites
  has_many :pages, class_name: "Comfy::Cms::Page", dependent: :destroy

  after_save :update_cms_page

  private

  def update_cms_page
    pages.each do |page|
      page.label = name
      page.save
    end
  end

  def safe_to_destroy
    if icca_sites.any?
      errors[:base] << "Attempted to delete #{self.name}, but sites found associated with that country. Delete those sites and try again."
      throw :abort
    end
  end
end
