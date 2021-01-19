class CreateConstituencies < ActiveRecord::Migration[6.1]
  def change
    create_table :constituencies do |t|
      t.integer :district_number
      t.string :region
      t.string :area
      t.integer :population
      t.integer :number_of_electors
      t.timestamps
    end
  end
end
