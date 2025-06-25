class CreateExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :exercises do |t|
     t.text :name, null: false
      t.text :force              # push, pull
      t.text :level              # beginner, intermediate, expert
      t.text :mechanic           # compound, isolation
      t.text :equipment          # barbell, dumbbell, etc.
      t.jsonb :primary_muscles, default: []
      t.jsonb :secondary_muscles, default: []
      t.jsonb :instructions, default: []
      t.text :category
      t.jsonb :image_urls, default: []
      t.text :description
      t.timestamps
    end
    add_index :exercises, :name, unique: true
  end
end
