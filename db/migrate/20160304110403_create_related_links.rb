class CreateRelatedLinks < ActiveRecord::Migration[4.2]
  def change
    create_table :related_links do |t|
      t.integer :page_id
      t.string :label
      t.string :url

      t.timestamps null: false
    end
  end
end
