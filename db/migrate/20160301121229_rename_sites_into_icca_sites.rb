class RenameSitesIntoIccaSites < ActiveRecord::Migration
  def change
    rename_table :sites, :icca_sites
  end
end
