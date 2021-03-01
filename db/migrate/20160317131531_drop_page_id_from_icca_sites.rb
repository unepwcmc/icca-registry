class DropPageIdFromIccaSites < ActiveRecord::Migration[4.2]
  def change
    remove_column :icca_sites, :page_id
  end
end
