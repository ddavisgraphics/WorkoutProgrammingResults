# frozen_string_literal: true

class Program < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  has_many :workouts, -> { order(:day_of_week, :position) }, dependent: :destroy

  # Enums
  enum :level, { beginner: 0, intermediate: 1, advanced: 2 }, prefix: true
  enum :visibility, { private: 0, public: 1, premium: 2 }, prefix: true

  # Validations
  validates :name, presence: true
  validates :weeks, presence: true, numericality: { greater_than: 0 }
  validates :active, inclusion: { in: [true, false] }
  validates :description, length: { maximum: 500 }, allow_blank: true
end
