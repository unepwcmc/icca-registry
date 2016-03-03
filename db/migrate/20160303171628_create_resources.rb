class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.integer :page_id

      t.timestamps null: false
    end
  end
end
