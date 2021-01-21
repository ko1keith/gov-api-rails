class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.integer :street_number
      t.string :postal_code
      t.string :region
      t.string :province
      t.string :unit
      t.timestamps
    end
  end
end
