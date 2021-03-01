class RenameSitesIntoIccaSites < ActiveRecord::Migration[4.2]
  def change
    rename_table :sites, :icca_sites
  end
end
