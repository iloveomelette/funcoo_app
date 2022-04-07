class CreateGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :genres do |t|
      t.references :recipe, null: false, foreign_key: true
      t.integer :staple_food, null: false, default: 0
      t.integer :main_dish, null: false, default: 0
      t.integer :side_dish, null: false, default: 0

      t.timestamps
    end
  end
end
