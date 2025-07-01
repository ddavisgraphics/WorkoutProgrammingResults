# frozen_string_literal: true

class Workout < ApplicationRecord
  belongs_to :program
  has_many :workout_exercises, dependent: :destroy
  has_many :exercises, through: :workout_exercises

  enum :day_of_week, {
    monday: 0,
    tuesday: 1,
    wednesday: 2,
    thursday: 3,
    friday: 4,
    saturday: 5,
    sunday: 6
  }

  validates :name, presence: true
  validates :day_of_week, presence: true, inclusion: { in: day_of_weeks.keys }
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
