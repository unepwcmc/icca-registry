class AddFileToResourcesTable < ActiveRecord::Migration[4.2]
  def change
    add_attachment :resources, :file
  end
end
