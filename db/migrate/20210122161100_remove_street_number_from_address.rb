class RemoveStreetNumberFromAddress < ActiveRecord::Migration[6.1]
  def change
    remove_column :addresses, :street_number
  end
end
