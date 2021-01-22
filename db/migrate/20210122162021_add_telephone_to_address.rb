class AddTelephoneToAddress < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :telephone, :string
  end
end
