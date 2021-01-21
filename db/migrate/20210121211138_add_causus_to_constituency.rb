class AddCaususToConstituency < ActiveRecord::Migration[6.1]
  def change
    add_column :constituencies, :current_caucus, :string
  end
end
