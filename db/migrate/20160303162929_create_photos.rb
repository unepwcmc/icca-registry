class CreatePhotos < ActiveRecord::Migration[4.2]
  def change
    create_table :photos do |t|
      t.integer :page_id

      t.timestamps null: false
    end
  end
end
