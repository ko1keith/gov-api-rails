class AddExpendituresToMember < ActiveRecord::Migration[6.1]
  def change
    add_reference :expenditures, :member, foreign_key: true, index: true
  end
end
