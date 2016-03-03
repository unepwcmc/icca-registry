class AddLabelToResourcesTable < ActiveRecord::Migration
  def change
    add_column :resources, :label, :string
  end
end
