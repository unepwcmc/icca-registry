class RemovePaperclipColumnsFromTables < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :file_file_name, :string
    remove_column :photos, :file_content_type, :string
    remove_column :photos, :file_file_size, :integer
    remove_column :photos, :file_updated_at, :datetime
    remove_column :resources, :file_file_name, :string
    remove_column :resources, :file_content_type, :string
    remove_column :resources, :file_file_size, :integer
    remove_column :resources, :file_updated_at, :datetime
  end
end
