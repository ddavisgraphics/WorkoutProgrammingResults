# frozen_string_literal: true

class WorkoutExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise

  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sets, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :reps, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :weight, numericality: { greater_than: 0 }, allow_nil: true
end
