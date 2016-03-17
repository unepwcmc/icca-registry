class ChangeLatAndLonToIccaSites < ActiveRecord::Migration
  def change
    remove_column :icca_sites, :lon
    remove_column :icca_sites, :lat

    add_column :icca_sites, :lon, :float
    add_column :icca_sites, :lat, :float
  end
end
