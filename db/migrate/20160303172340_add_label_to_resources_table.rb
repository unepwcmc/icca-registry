class AddLabelToResourcesTable < ActiveRecord::Migration[4.2]
  def change
    add_column :resources, :label, :string
  end
end
