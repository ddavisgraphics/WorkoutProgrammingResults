class CreatePrograms < ActiveRecord::Migration[8.0]
  def change
    create_table :programs do |t|
      t.references :user, foreign_key: true
      t.text :name
      t.integer :weeks
      t.boolean :active
      t.timestamps
    end
  end
end
