class CreateExpenditures < ActiveRecord::Migration[6.1]
  def change
    create_table :expenditures do |t|
      t.string :category, nullable: false
      t.string :subcategory
      t.date :start_date, nullable: false
      t.date :end_date, nullable: false
      t.decimal :member_budget
      t.decimal :resources_provided_by_house
      t.timestamps
    end
  end
end
