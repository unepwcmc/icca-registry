class AddFileToResourcesTable < ActiveRecord::Migration
  def change
    add_attachment :resources, :file
  end
end
