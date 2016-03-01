class AddCountryAndIccaSiteToComfyPages < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :country_id, :integer
    add_column :comfy_cms_pages, :icca_site_id, :integer
  end
end
