class AddProgramIdToWorkouts < ActiveRecord::Migration[8.0]
  def change
    add_reference :workouts, :program, foreign_key: true
  end
end
