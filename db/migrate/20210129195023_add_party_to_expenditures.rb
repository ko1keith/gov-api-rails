class AddPartyToExpenditures < ActiveRecord::Migration[6.1]
  def change
    add_column :expenditures, :party, :string
  end
end
