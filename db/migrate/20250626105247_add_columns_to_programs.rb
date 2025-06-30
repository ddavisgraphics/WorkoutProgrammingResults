class AddColumnsToPrograms < ActiveRecord::Migration[8.0]
  def change
    add_column :programs, :level, :string
    add_column :programs, :estimated_time_per_workout, :string
    add_column :programs, :days_per_week, :integer
    add_column :programs, :visibility, :integer, default: 0, null: false
  end
end
