class RemoveDaysPerWeekFromPrograms < ActiveRecord::Migration[8.0]
  def change
    remove_column :programs, :days_per_week
  end
end
