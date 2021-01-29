class AddTotalToExpenditures < ActiveRecord::Migration[6.1]
  def change
    add_column :expenditures, :total, :decimal
  end
end
