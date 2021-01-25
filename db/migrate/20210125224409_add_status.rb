class AddStatus < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :status, :string
  end
end
