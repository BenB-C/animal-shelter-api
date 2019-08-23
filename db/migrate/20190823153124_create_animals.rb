class CreateAnimals < ActiveRecord::Migration[5.2]
  def change
    create_table :animals do |t|
      t.string :type # dog or cat
      t.string :name
      t.string :breed
      t.string :sex
      t.integer :age_years
      t.integer :age_months
      t.decimal :weight
      t.timestamps
    end
  end
end
