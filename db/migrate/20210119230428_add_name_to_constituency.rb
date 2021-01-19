class AddNameToConstituency < ActiveRecord::Migration[6.1]
  def change
    add_column :constituencies, :name, :string, nullable: false
  end
end
