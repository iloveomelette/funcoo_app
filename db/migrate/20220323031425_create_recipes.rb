class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.string :menu_image
      t.integer :cooking_time
      t.integer :cooking_cost
      t.integer :calorie

      t.timestamps
    end
  end
end
