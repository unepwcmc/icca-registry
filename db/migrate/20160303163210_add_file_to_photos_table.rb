class AddFileToPhotosTable < ActiveRecord::Migration[4.2]
  def change
    add_attachment :photos, :file
  end
end
