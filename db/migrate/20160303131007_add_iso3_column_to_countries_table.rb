class AddIso3ColumnToCountriesTable < ActiveRecord::Migration
  def change
    add_column :countries, :iso_3, :string
  end
end
