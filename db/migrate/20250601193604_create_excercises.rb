class CreateExcercises < ActiveRecord::Migration[8.0]
  def change
    create_table :excercises do |t|
      t.timestamps
    end
  end
end
