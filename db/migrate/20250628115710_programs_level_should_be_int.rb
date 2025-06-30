class ProgramsLevelShouldBeInt < ActiveRecord::Migration[8.0]
  def change
    change_column :programs, :level, :integer, using: 'level::integer', default: 0, null: false
  end
end
