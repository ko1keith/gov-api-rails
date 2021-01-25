class AddExpendituresToConstituency < ActiveRecord::Migration[6.1]
  def change
    add_reference :expenditures, :constituency, foreign_key: true, index: true
  end
end
