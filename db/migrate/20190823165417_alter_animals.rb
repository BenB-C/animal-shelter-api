class AlterAnimals < ActiveRecord::Migration[5.2]
  def change
    remove_column :animals, :age_months
    change_column :animals, :age_years, :decimal
    rename_column :animals, :age_years, :age
  end
end
