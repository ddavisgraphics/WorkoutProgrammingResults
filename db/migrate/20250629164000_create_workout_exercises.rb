class CreateWorkoutExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_exercises do |t|
      t.references :workout, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :sets
      t.integer :reps
      t.decimal :weight
      t.integer :position, null: false
      t.timestamps
    end

    # Add a unique index to prevent duplicate exercises in the same workout
    add_index :workout_exercises, %i[workout_id exercise_id position], unique: true,
                                                                       name: 'index_workout_exercises_uniqueness'
  end
end
