class Country < ActiveRecord::Base
  has_many :icca_sites
  has_one :page, class_name: "Comfy::Cms::Page"

  after_save :update_cms_page

  private

  def update_cms_page
    if page
      page.label = name
      page.save
    end
  end
end
