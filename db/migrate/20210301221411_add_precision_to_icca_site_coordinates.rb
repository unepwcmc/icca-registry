class AddPrecisionToIccaSiteCoordinates < ActiveRecord::Migration[5.2]
  def up
    change_column :icca_sites, :lat, :decimal, precision: 4, scale: 2
    change_column :icca_sites, :lon, :decimal, precision: 5, scale: 2
  end

  def down 
    change_column :icca_sites, :lat, :float
    change_column :icca_sites, :lon, :float
  end
end
