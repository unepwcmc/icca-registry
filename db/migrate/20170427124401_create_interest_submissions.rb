class CreateInterestSubmissions < ActiveRecord::Migration[4.2]
  def change
    create_table :interest_submissions do |t|
      t.text :icca_name
      t.text :country
      t.text :icca_size
      t.text :email
      t.boolean :can_contact

      t.timestamps
    end
  end
end
