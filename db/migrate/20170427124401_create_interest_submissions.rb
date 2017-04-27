class CreateInterestSubmissions < ActiveRecord::Migration
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
