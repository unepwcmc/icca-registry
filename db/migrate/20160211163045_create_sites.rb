class CreateSites < ActiveRecord::Migration[4.2][4.2]
  def change
    create_table :sites do |t|
      t.string   "name"
      t.string   "lat"
      t.string   "lon"

      t.integer  "country_id"
      t.integer  "page_id"

      t.timestamps null: false
    end
  end
end
