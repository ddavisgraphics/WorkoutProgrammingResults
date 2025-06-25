# frozen_string_literal: true

# Building block for many models to have a reference to an exercise.
# This is a common pattern in fitness applications where exercises are reused across different workouts and logs.
class Exercise < ApplicationRecord
  has_many :user_maxes
  has_many :workout_logs
  has_many_attached :images

  validates :name, presence: true, uniqueness: true

  def primary_image_url
    images.first&.url
  end
end
