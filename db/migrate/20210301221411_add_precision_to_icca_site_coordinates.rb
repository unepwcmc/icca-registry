class AddPrecisionToIccaSiteCoordinates < ActiveRecord::Migration[5.2]
  def up
    change_column :icca_sites, :lat, :decimal, precision: 9, scale: 7
    change_column :icca_sites, :lon, :decimal, precision: 10, scale: 7
  end

  def down 
    change_column :icca_sites, :lat, :float
    change_column :icca_sites, :lon, :float
  end
end
