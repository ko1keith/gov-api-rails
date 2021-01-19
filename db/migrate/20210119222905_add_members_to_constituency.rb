class AddMembersToConstituency < ActiveRecord::Migration[6.1]
  def change
    add_reference :members, :constituency, foreign_key: true
  end
end
