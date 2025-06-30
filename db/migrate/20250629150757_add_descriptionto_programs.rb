class AddDescriptiontoPrograms < ActiveRecord::Migration[8.0]
  def change
    add_column :programs, :description, :text, null: true, default: nil
  end
end
