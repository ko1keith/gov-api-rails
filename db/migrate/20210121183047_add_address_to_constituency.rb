class AddAddressToConstituency < ActiveRecord::Migration[6.1]
  def change
    add_reference :addresses, :constituency, foreign_key: true, index: true
  end
end
