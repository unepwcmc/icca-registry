class AddIso3ColumnToCountriesTable < ActiveRecord::Migration[4.2]
  def change
    add_column :countries, :iso_3, :string
  end
end
