class ChangeDecimalsToFloats < ActiveRecord::Migration[5.2]
  def change
    change_column :animals, :age, :float
    change_column :animals, :weight, :float
  end
end
