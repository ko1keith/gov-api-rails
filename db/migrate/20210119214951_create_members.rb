class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :email, nullable: false
      t.string :first_name, nullable: false
      t.string :last_name, nullable: false
      t.string :website
      t.string :party, nullable: false
      t.timestamps
    end
  end
end
