class CreateWorkouts < ActiveRecord::Migration[8.0]
  def change
    create_table :workouts do |t|
      t.string :name
      t.integer :day_of_week
      t.integer :position
      t.timestamps
    end
  end
end
