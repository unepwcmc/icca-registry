class DropPageIdFromIccaSites < ActiveRecord::Migration
  def change
    remove_column :icca_sites, :page_id
  end
end
