class Country < ApplicationRecord
  has_many :icca_sites
  has_many :pages, class_name: "Comfy::Cms::Page"

  after_save :update_cms_page

  private

  def update_cms_page
    pages.each do |page|
      page.label = name
      page.save
    end
  end
end
